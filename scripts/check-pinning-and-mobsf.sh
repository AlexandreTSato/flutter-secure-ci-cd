#!/usr/bin/env bash
set -euo pipefail

REPORT="mobsfscan-report.json"
APK_DIR="decompiled_apk"   # suposição: seu pipeline já decompilou o AAB/APK aqui
MANIFEST_PATH="apps/appbank/android/app/src/main/AndroidManifest.xml" # ajuste se necessário

# Helper: procura network_security_config xml referenciado no manifest
function find_network_security_config() {
  if [ -f "$MANIFEST_PATH" ]; then
    grep -oP 'android:networkSecurityConfig\s*=\s*"(?:@xml/)?\K[^"]+' "$MANIFEST_PATH" || true
  fi
}

# 1) Leitura direta do MobSF (se existir)
if [ -f "$REPORT" ]; then
  echo "== MobSF raw keys detected =="
  jq -r '.results | keys[]' "$REPORT" || true
  # pegando o nível do android_ssl_pinning (se existir)
  SSL_MSF_SEV=$(jq -r '.results.android_ssl_pinning.metadata.severity // empty' "$REPORT" || echo "")
  echo "MobSF android_ssl_pinning severity: ${SSL_MSF_SEV:-(none)}"
fi

# 2) Checagens locais: network_security_config.xml (res/xml)
NSC_NAME=$(find_network_security_config || true)
if [ -n "$NSC_NAME" ]; then
  echo "Found networkSecurityConfig referenced in manifest: $NSC_NAME"
  # path comum: android/app/src/main/res/xml/<name>.xml
  NSC_PATH=$(find apps -type f -name "${NSC_NAME#@xml/}*" | head -n1 || true)
  if [ -n "$NSC_PATH" ] && [ -f "$NSC_PATH" ]; then
    echo "Found NSC file: $NSC_PATH"
    grep -n "<pin-set" "$NSC_PATH" || true
    grep -n "pin-set" "$NSC_PATH" || true
    if grep -q "<pin-set" "$NSC_PATH"; then
      echo "✅ network_security_config contains <pin-set> -> likely pinning defined in XML."
      NSC_PIN_FOUND=true
    else
      NSC_PIN_FOUND=false
    fi
  else
    echo "No local NSC file found at expected locations."
    NSC_PIN_FOUND=false
  fi
else
  echo "No networkSecurityConfig referenced in manifest."
  NSC_PIN_FOUND=false
fi

# 3) Grep em código decompilado (procura CertificatePinner / TrustManager / TrustKit)
# Se você não tem os artefatos decompilados no CI, tente procurar no source tree (android/app or libs)
echo "== Grep for CertificatePinner / TrustManager / TrustKit / pin-set in source =="
grep -R --line-number --exclude-dir=.git -E "CertificatePinner|CertificatePinner.Builder|okhttp3.CertificatePinner|TrustKit|X509TrustManager|checkServerTrusted|pin-set|pinset|setPinnedCertificates" . || true

# 4) Heurística final: decide se pinning aparenta existir
if [ "${NSC_PIN_FOUND}" = true ]; then
  echo "CONCLUSION: Pinning found via network_security_config.xml"
  PINNING_DETECTED=true
else
  # fallback: se encontramos CertificatePinner no código
  if grep -R --line-number --exclude-dir=.git -E "CertificatePinner|CertificatePinner.Builder|okhttp3.CertificatePinner" . >/dev/null 2>&1; then
    echo "CONCLUSION: Pinning detected via CertificatePinner usage"
    PINNING_DETECTED=true
  else
    echo "CONCLUSION: No static evidence of pinning found (could be runtime/dynamic)."
    PINNING_DETECTED=false
  fi
fi

# 5) Correlaciona com o MobSF outcome
if [ -n "$SSL_MSF_SEV" ]; then
  echo "MobSF reported ssl_pinning severity: $SSL_MSF_SEV"
  if [ "$SSL_MSF_SEV" = "ERROR" ] || [ "$SSL_MSF_SEV" = "WARNING" ]; then
    echo "MobSF indicates an issue (WARNING/ERROR) with pinning - require manual review or stronger check."
  elif [ "$SSL_MSF_SEV" = "INFO" ]; then
    if [ "$PINNING_DETECTED" = true ]; then
      echo "MobSF says INFO but local checks found pinning -> likely false positive from MobSF (OK)."
      exit 0
    else
      echo "MobSF INFO and no local evidence -> flag for manual review (possible missing pinning)."
      exit 2
    fi
  else
    echo "No MobSF ssl_pinning entry; using local detection result."
  fi
fi

if [ "$PINNING_DETECTED" = true ]; then
  echo "✅ SSL pinning detected (static checks)."
  exit 0
else
  echo "❌ SSL pinning NOT detected by static checks (MobSF may be correct)."
  # return code non-zero to surface fail in CI (adjust policy as needed)
  exit 2
fi
