#!/usr/bin/env bash
# security-checks.sh — versão final validada
# ----------------------------------------------------------------------------------
# Este script realiza validações SAST avançadas sobre o APK/AAB decompilado,
# garantindo parte das conformidade com OWASP MASVS, OWASP Mobile Top 10 e requisitos
# comuns de segurança de apps bancários.
# ----------------------------------------------------------------------------------

set -euo pipefail

########################################
# CONFIGURAÇÃO
########################################
SECURITY_FAIL_ON_CRITICAL="${SECURITY_FAIL_ON_CRITICAL:-true}"
HIGH_FAIL_THRESHOLD="${HIGH_FAIL_THRESHOLD:-1}"

SAST_TMP_DIR="${SAST_TMP_DIR:-sast_tmp}"
SAST_REPORTS_DIR="${SAST_REPORTS_DIR:-sast_reports}"
CI_SUMMARY_DIR="$SAST_REPORTS_DIR/ci-summary"
SAST_SCRIPTS_DIR="${SAST_SCRIPTS_DIR:-scripts}"

mkdir -p "$SAST_REPORTS_DIR"
mkdir -p "$CI_SUMMARY_DIR"

########################################
# MÉTRICAS
########################################
SCRIPT_START_TIME=$(date +%s)

CRITICAL=0
HIGH=0
MEDIUM=0
RECOMMEND=0

########################################
# EXCLUDES
########################################
EXCLUDE_DIRS=(
  build
  .gradle
  .dart_tool
  scripts
  "$SAST_REPORTS_DIR"
  .github
  node_modules
  outputs
  test
  mock
  example
  sample
  .git
  jadx
  apktool
)

EXCLUDE_ARGS=()
for d in "${EXCLUDE_DIRS[@]}"; do
  EXCLUDE_ARGS+=(--exclude-dir="$d")
done

########################################
# safe_grep
# Função centralizada que garante:
# - Filtrar arquivos irrelevantes (md, toml, license, etc)
# - Evitar falsos positivos sem perder segurança real
########################################
safe_grep() {
    local pattern="$1"
    local path="${2:-$SAST_TMP_DIR}"

    grep -RIn --color=never \
        "${EXCLUDE_ARGS[@]}" \
        --exclude="*.md" \
        --exclude="*.MD" \
        --exclude="*.txt" \
        --exclude="*.toml" \
        --exclude="*.yaml" \
        --exclude="*.yml" \
        --exclude="*.json" \
        --exclude="LICENSE" \
        --exclude="NOTICE" \
        -E "$pattern" "$path" || true
}

append_report() {
    local file="$1"; shift
    echo "$@" >> "$file"
}

########################################
# SANITY CHECK
########################################
if [ ! -d "$SAST_TMP_DIR" ]; then
  echo "❌ ERROR: Diretório decompilado não encontrado."
  exit 2
fi

ANALYZED_FILES_COUNT=$(find "$SAST_TMP_DIR" -type f 2>/dev/null | wc -l || echo 0)
ANALYZED_DIR_SIZE_MB=$(du -sm "$SAST_TMP_DIR" 2>/dev/null | cut -f1 || echo 0)
ANALYZED_LINES=$(find "$SAST_TMP_DIR" -type f -exec wc -l {} + | awk '{s+=$1} END {print s+0}')

########################################
# SECTION CRITICAL
# MASVS-L2/MASVS-RESILIENCE e bancos
########################################
SECTION_CRITICAL_START=$(date +%s)

########################################
# 1.1 android:debuggable="true"
# MASVS-STORAGE-1 — remover informações de debug em produção
########################################
if safe_grep 'android:debuggable="true"' | grep -q .; then
    append_report "$SAST_REPORTS_DIR/critical-debuggable.txt" "Found android:debuggable=true"
    echo "❌ CRITICAL: android:debuggable=true"
    CRITICAL=$((CRITICAL+1))
fi

########################################
# 1.2 TrustManager permissivo
# MASVS-NETWORK-1 — validação de certificados
########################################
TRUST_MATCH=$(safe_grep -E "TrustManager|X509TrustManager" | grep -Ei "checkServerTrusted|return true|acceptAllCerts" || true)
if [[ -n "$TRUST_MATCH" ]]; then
    append_report "$SAST_REPORTS_DIR/critical-trustmanager.txt" "$TRUST_MATCH"
    echo "❌ CRITICAL: TrustManager permissivo"
    CRITICAL=$((CRITICAL+1))
fi

########################################
# 1.3 HostnameVerifier permissivo
# MASVS-NETWORK-1 — evitar MITM
########################################
HOST_MATCH=$(safe_grep -E "HostnameVerifier" | grep -Ei "return true" || true)
if [[ -n "$HOST_MATCH" ]]; then
    append_report "$SAST_REPORTS_DIR/critical-hostnameverifier.txt" "$HOST_MATCH"
    echo "❌ CRITICAL: HostnameVerifier permissivo"
    CRITICAL=$((CRITICAL+1))
fi

########################################
# 1.4 Hardcoded secrets
# MASVS-STORAGE-2 / OWASP M6
########################################
HARD_SECRETS=$(safe_grep -E "AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|-----BEGIN [A-Z ]*PRIVATE KEY-----|client_secret|api_key|SECRET_KEY|JWT_SECRET")
if [[ -n "$HARD_SECRETS" ]]; then
    append_report "$SAST_REPORTS_DIR/critical-hardcoded-secrets.txt" "$HARD_SECRETS"
    echo "❌ CRITICAL: Hardcoded secrets"
    CRITICAL=$((CRITICAL+1))
else
    echo "✅ No hardcoded secrets detected."
fi

########################################
# 1.5 Exported providers com acesso sensível
# MASVS-PLATFORM-4
########################################
EXPORTED_PROVIDERS=$(safe_grep 'android:exported="true"' | grep -Ei "provider" || true)
if [[ -n "$EXPORTED_PROVIDERS" ]]; then
    if echo "$EXPORTED_PROVIDERS" | grep -Ei "fileprovider|file|external" >/dev/null; then
        append_report "$SAST_REPORTS_DIR/critical-exported-providers.txt" "$EXPORTED_PROVIDERS"
        echo "❌ CRITICAL: Exported provider com risco"
        CRITICAL=$((CRITICAL+1))
    fi
fi

########################################
# SECTION HIGH
# MASVS-L2 e MASVS-NETWORK
########################################
SECTION_HIGH_START=$(date +%s)

########################################
# 2.1 usesCleartextTraffic
# MASVS-NETWORK-2 — comunicação segura
########################################
if safe_grep 'usesCleartextTraffic="true"' | grep -q .; then
    append_report "$SAST_REPORTS_DIR/high-cleartext.txt" "usesCleartextTraffic=true"
    echo "⚠️ HIGH: cleartext traffic enabled"
    HIGH=$((HIGH+1))
fi

########################################
# 2.1.1 HTTP URLs inseguras
# OWASP M3 / MASVS-NETWORK
########################################
REPORT_FILE="$SAST_REPORTS_DIR/high-http-urls.txt"
HTTP_URLS=$(safe_grep "http:\/\/[a-zA-Z0-9]")

SAFE_DOMAINS_REGEX='(schemas\.android\.com|w3\.org|purl\.org|apache\.org|openxmlformats.org|apple\.com)'

if [[ -n "$HTTP_URLS" ]]; then
    FILTERED_URLS=$(echo "$HTTP_URLS" | grep -vE "$SAFE_DOMAINS_REGEX" || true)

    if [[ -n "$FILTERED_URLS" ]]; then
        echo "$FILTERED_URLS" > "$REPORT_FILE"
        echo "⚠️ HIGH: HTTP inseguro detectado"
        HIGH=$((HIGH+1))
    else
        echo "✅ Nenhuma URL http insegura após filtragem."
    fi
else
    echo "✅ Nenhuma URL http encontrada."
fi

########################################
# 2.2 allowBackup
# MASVS-STORAGE-1
########################################
if safe_grep 'allowBackup="true"' | grep -q .; then
    append_report "$SAST_REPORTS_DIR/high-allowbackup.txt" "allowBackup=true"
    echo "⚠️ HIGH: allowBackup habilitado"
    HIGH=$((HIGH+1))
fi

########################################
# 2.4 SSL Pinning 
# MASVS-NETWORK-1
########################################
PINNING_FOUND="false"

if safe_grep -E "CertificatePinner|okhttp3\.CertificatePinner" | grep -q .; then
    PINNING_FOUND="true"
    append_report "$SAST_REPORTS_DIR/ssl-pinning-found.txt" "Found CertificatePinner"
fi

if find "$SAST_TMP_DIR" -name "network_security_config.xml" -exec grep -q "<pin-set" {} \; -print -quit 2>/dev/null | grep -q .; then
    PINNING_FOUND="true"
    append_report "$SAST_REPORTS_DIR/ssl-pinning-found.txt" "<pin-set found>"
fi

if [[ "$PINNING_FOUND" == "false" ]]; then
    append_report "$SAST_REPORTS_DIR/high-no-ssl-pinning.txt" "No SSL pinning found"
    echo "⚠️ HIGH: SSL Pinning ausente"
    HIGH=$((HIGH+1))
else
    echo "✅ SSL Pinning detectado"
fi

########################################
# 2.5 Ausência de root detection
# MASVS-RESILIENCE
########################################
if ! safe_grep -E "RootBeer|isDeviceRooted|isRooted|/system/xbin/su" | grep -q .; then
    append_report "$SAST_REPORTS_DIR/high-no-root-detection.txt" "Root detection ausente"
    echo "⚠️ HIGH: Nenhum root detection encontrado"
    HIGH=$((HIGH+1))
fi

########################################
# 2.6 debug keystore
########################################
DEBUG_KEYSTORE=$(safe_grep -E "Android Debug|debug.keystore|CN=Android Debug")
if [[ -n "$DEBUG_KEYSTORE" ]]; then
    append_report "$SAST_REPORTS_DIR/high-debug-keystore.txt" "$DEBUG_KEYSTORE"
    echo "⚠️ HIGH: debug keystore detectado"
    HIGH=$((HIGH+1))
fi

########################################
# SECTION MEDIUM
########################################
SECTION_MEDIUM_START=$(date +%s)

########################################
# 3.1 Root detection presente (informativo)
########################################
FOUND_ROOT=$(safe_grep -E "RootBeer|isDeviceRooted|isRooted|/system/xbin/su" || true)
if [[ -n "$FOUND_ROOT" ]]; then
    append_report "$SAST_REPORTS_DIR/medium-root-checks.txt" "$FOUND_ROOT"
    echo "ℹ️ MEDIUM: Root detection presente"
    MEDIUM=$((MEDIUM+1))
fi

########################################
# 3.2 Weak crypto (MD5/SHA1)
########################################
WEAK_CRYPTO=$(safe_grep -E "MD5|SHA-1|SHA1" || true)
if [[ -n "$WEAK_CRYPTO" ]]; then
    append_report "$SAST_REPORTS_DIR/medium-weak-crypto.txt" "$WEAK_CRYPTO"
    echo "ℹ️ MEDIUM: uso de crypto fraca detectado"
    MEDIUM=$((MEDIUM+1))
fi

########################################
# 3.3 Obfuscation (ou ausência)
# MASVS-RESILIENCE
########################################
OBF=$(safe_grep -E "proguard|minifyEnabled|R8|com.guardsquare" || true)
if [[ -n "$OBF" ]]; then
    append_report "$SAST_REPORTS_DIR/medium-obfuscation.txt" "$OBF"
else
    append_report "$SAST_REPORTS_DIR/medium-obfuscation.txt" "No obfuscation indicators found"
    echo "⚠️ HIGH: Nenhuma evidência de obfuscation"
    HIGH=$((HIGH+1))
fi

########################################
# SECTION RECOMMEND
########################################
SECTION_RECOMMEND_START=$(date +%s)

########################################
# 4. Tamper detection (SafetyNet, Play Integrity)
# MASVS-RESILIENCE
########################################
TAMPER=$(safe_grep -E "SafetyNet|PlayIntegrity|SignatureVerifier")
if [[ -z "$TAMPER" ]]; then
    echo "🟢 RECOMMEND: adicionar SafetyNet / Play Integrity"
    RECOMMEND=$((RECOMMEND+1))
fi

########################################
# 4.x Native debug (informativo)
########################################
NATIVE=$(safe_grep -E "gdbserver|ndk-stack|DT_DEBUG|\\.sym")
if [[ -n "$NATIVE" ]]; then
    append_report "$SAST_REPORTS_DIR/medium-native-debug.txt" "$NATIVE"
    echo "ℹ️ MEDIUM: indicadores nativos de debug detectados"
    MEDIUM=$((MEDIUM+1))
fi

########################################
# targetSdkVersion
########################################
TARGET_SDK_RAW=$(safe_grep "targetSdkVersion" || true)
TARGET_SDK_NUM=$(echo "$TARGET_SDK_RAW" | grep -oE '[0-9]+' | head -n1 || true)

if [[ -n "$TARGET_SDK_NUM" ]]; then
    if (( TARGET_SDK_NUM < 34 )); then
        echo "❌ targetSdkVersion baixo ($TARGET_SDK_NUM)"
        HIGH=$((HIGH+1))
    else
        echo "✅ targetSdkVersion OK ($TARGET_SDK_NUM)"
    fi
else
    echo "⚠️ targetSdkVersion não encontrado"
fi

########################################
# SUMMARY FINAL
########################################
SECTION_SUMMARY_START=$(date +%s)

echo "=== SAST SUMMARY ==="
echo "CRITICAL: $CRITICAL"
echo "HIGH:     $HIGH"
echo "MEDIUM:   $MEDIUM"
echo "RECOMMEND:$RECOMMEND"

cat > "$CI_SUMMARY_DIR/summary.txt" <<EOF
CRITICAL=$CRITICAL
HIGH=$HIGH
MEDIUM=$MEDIUM
RECOMMEND=$RECOMMEND
EOF

cp "$SAST_REPORTS_DIR"/* "$CI_SUMMARY_DIR"/ 2>/dev/null || true

########################################
# METRICS
########################################
SCRIPT_END_TIME=$(date +%s)
TOTAL=$((SCRIPT_END_TIME - SCRIPT_START_TIME))

echo ""
echo "===== METRICS ====="
echo "📊 Files: $ANALYZED_FILES_COUNT"
echo "📦 Size: ${ANALYZED_DIR_SIZE_MB}MB"
echo "📄 Lines: $ANALYZED_LINES"
echo "⏱️ Total: ${TOTAL}s"
echo "===================="

########################################
# EXIT POLICY
########################################
if [[ "$SECURITY_FAIL_ON_CRITICAL" == "true" && $CRITICAL -gt 0 ]]; then
    echo "❌ Build failed: CRITICAL issues detected."
    exit 1
fi

if (( HIGH >= HIGH_FAIL_THRESHOLD )); then
    echo "❌ Build failed: HIGH >= threshold"
    exit 1
fi

echo "✅ OK — Nenhum bloqueio crítico."
exit 0
