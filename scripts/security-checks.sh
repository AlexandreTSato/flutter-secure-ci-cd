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
    # aceita opções do grep (ex: -E) antes do padrão
    local GREP_OPTS=()
    local pattern=""
    local path="$SAST_TMP_DIR"

    # coletar opções que comecem com '-'
    while [[ $# -gt 0 && "$1" == -* ]]; do
        GREP_OPTS+=("$1")
        shift
    done

    pattern="${1:-}"
    shift || true
    if [[ -n "${1:-}" ]]; then
        path="$1"
    fi

    [[ -z "$pattern" ]] && return 0

    grep -RIn --color=never --binary-files=without-match \
        "${GREP_OPTS[@]}" \
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
        -E "$pattern" "$path" 2>/dev/null || true
}

append_report() {
    local file="$1"; shift
    echo "$@" >> "$file"
}

write_sast_summary() {
  mkdir -p "$SAST_REPORTS_DIR"
  SUMMARY_FILE="$SAST_REPORTS_DIR/summary.txt"
  {
    echo "=== SAST SUMMARY ==="
    echo "CRITICAL: $CRITICAL"
    echo "HIGH:     $HIGH"
    echo "MEDIUM:   $MEDIUM"
    echo "RECOMMEND:$RECOMMEND"
    echo ""
    echo "===== METRICS ====="
    echo "Files: $(find . -type f 2>/dev/null | wc -l || echo 0)"
    echo "Size (MB): $(du -sm . 2>/dev/null | cut -f1 || echo 0)MB"
    echo "Lines: $(find . -type f -exec wc -l {} + | awk '{s+=$1} END {print s+0}')"
    echo "===================="
    echo ""
    echo "Reports in $SAST_REPORTS_DIR:"
    ls -la "$SAST_REPORTS_DIR" || true
    echo ""
    echo "---- Content preview (each report up to 200 lines) ----"
    for f in "$SAST_REPORTS_DIR"/*; do
      if [ -f "$f" ]; then
        echo "----- $f -----"
        sed -n '1,200p' "$f" || true
        echo ""
      fi
    done
  } > "$SUMMARY_FILE" 2>&1

  # also print to stdout so CI step log contains it
  echo "----- SAST SUMMARY (printed) -----"
  sed -n '1,500p' "$SUMMARY_FILE" || true
  echo "----------------------------------"
}

# garante que o resumo seja escrito/imprimido em qualquer saída (success ou fail)
trap write_sast_summary EXIT

# nova função: tenta SAST_TMP_DIR -> código-fonte -> mapping/build outputs
search_evidence() {
    local pattern="$1"
    local repo_path="${2:-apps/appbank}"

    # 1) SAST_TMP_DIR via safe_grep
    local res
    res=$(safe_grep -E "$pattern" || true)
    if [[ -n "$res" ]]; then
        printf "%s\n" "$res"
        return 0
    fi

    # 2) código-fonte (fallback)
    res=$(grep -RIn --binary-files=without-match -E "$pattern" "$repo_path" 2>/dev/null || true)
    if [[ -n "$res" ]]; then
        printf "%s\n" "$res"
        return 0
    fi

    # 3) mapping.txt / outputs de build
    res=$(find "$repo_path" -path "*/build/*/outputs/mapping/*/mapping.txt" -type f -print -exec grep -InE "$pattern" {} + 2>/dev/null || true)
    if [[ -n "$res" ]]; then
        printf "%s\n" "$res"
        return 0
    fi

    return 1
}


# Inserir a seguir: função que prioriza build.gradle.kts -> build outputs -> APK
get_project_target_sdk() {
  local line file match sdk

  # 1) Kotlin DSL app module (authoritative)
  if [[ -f "apps/appbank/android/app/build.gradle.kts" ]]; then
    line=$(grep -E "targetSdk\s*=\s*[0-9]+" apps/appbank/android/app/build.gradle.kts || true)
    if [[ -n "$line" ]]; then
      sdk=$(echo "$line" | sed -nE 's/.*targetSdk\s*=\s*([0-9]+).*/\1/p' || true)
      printf "%s\n" "apps/appbank/android/app/build.gradle.kts: targetSdk=${sdk}"
      return 0
    fi
  fi

  # 2) Groovy DSL (targetSdkVersion) in android sources
  line=$(grep -R --binary-files=without-match -E "targetSdkVersion\s*[=:]?\s*\"?[0-9]+\"?" apps/appbank/android 2>/dev/null | head -n1 || true)
  if [[ -n "$line" ]]; then
    file="${line%%:*}"
    match="${line#*:}"
    sdk=$(echo "$match" | sed -nE 's/.*([0-9]+).*/\1/p' || true)
    printf "%s\n" "${file}: targetSdkVersion=${sdk}"
    return 0
  fi

  # 3) merged manifests / build outputs (android:targetSdkVersion)
  line=$(grep -R --binary-files=without-match -E 'android:targetSdkVersion\s*=\s*"[0-9]+"' apps/appbank/build 2>/dev/null | head -n1 || true)
  if [[ -n "$line" ]]; then
    file="${line%%:*}"
    match="${line#*:}"
    sdk=$(echo "$match" | sed -nE 's/.*"([0-9]+)".*/\1/p' || true)
    printf "%s\n" "${file}: android:targetSdkVersion=${sdk}"
    return 0
  fi

  # 4) fallback: app module -> whole repo
  line=$(grep -R --binary-files=without-match -E "targetSdk\s*=\s*[0-9]+|targetSdkVersion\s*[=:]?\s*\"?[0-9]+\"?" apps/appbank 2>/dev/null | head -n1 || true)
  if [[ -n "$line" ]]; then
    file="${line%%:*}"
    match="${line#*:}"
    sdk=$(echo "$match" | sed -nE 's/.*([0-9]+).*/\1/p' || true)
    printf "%s\n" "${file}: targetSdk=${sdk}"
    return 0
  fi

  line=$(grep -R --binary-files=without-match -E "targetSdk\s*=\s*[0-9]+|targetSdkVersion\s*[=:]?\s*\"?[0-9]+\"?" . 2>/dev/null | head -n1 || true)
  if [[ -n "$line" ]]; then
    file="${line%%:*}"
    match="${line#*:}"
    sdk=$(echo "$match" | sed -nE 's/.*([0-9]+).*/\1/p' || true)
    printf "%s\n" "${file}: targetSdk=${sdk}"
    return 0
  fi

  # 5) final fallback: scan APK/AAB if present (scan binary as text)
  if [[ -f "sast_tmp/app-universal.apk" ]]; then
    line=$(grep -a -E -n "targetSdkVersion|targetSdk" sast_tmp/app-universal.apk | head -n1 || true)
    if [[ -n "$line" ]]; then
      match="${line#*:}"
      sdk=$(echo "$match" | sed -nE 's/.*([0-9]{2,3}).*/\1/p' || true)
      printf "%s\n" "sast_tmp/app-universal.apk: targetSdk=${sdk}"
      return 0
    fi
  fi

  return 1
}

# extração robusta do número do SDK (usa último grupo numérico)
TARGET_RAW=$(get_project_target_sdk || true)
TARGET_SDK_NUM=$(echo "$TARGET_RAW" | grep -oE '[0-9]+' | tail -n1 || true)


########################################
# SANITY CHECK
########################################
if [ ! -d "$SAST_TMP_DIR" ]; then
  echo "⚠️ WARNING: Diretório decompilado ($SAST_TMP_DIR) não encontrado — usando fallback para código-fonte/build outputs."
  SAST_TMP_PRESENT="false"
else
  SAST_TMP_PRESENT="true"
fi

ANALYZED_FILES_COUNT=$(find "${SAST_TMP_DIR:-.}" -type f 2>/dev/null | wc -l || echo 0)
ANALYZED_DIR_SIZE_MB=$(du -sm "${SAST_TMP_DIR:-.}" 2>/dev/null | cut -f1 || echo 0)
ANALYZED_LINES=$(find "${SAST_TMP_DIR:-.}" -type f -exec wc -l {} + | awk '{s+=$1} END {print s+0}')

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
# ** Redudante Sempgrep **
TRUST_MATCH=$(safe_grep -E "TrustManager|X509TrustManager" | grep -Ei "checkServerTrusted|return true|acceptAllCerts" || true)
if [[ -n "$TRUST_MATCH" ]]; then
    append_report "$SAST_REPORTS_DIR/critical-trustmanager.txt" "$TRUST_MATCH"
    echo "❌ MEDIUM: TrustManager permissivo - Redudante Sempgrep"
    MEDIUM=$((MEDIUM+1))
fi

########################################
# 1.3 HostnameVerifier permissivo
# MASVS-NETWORK-1 — evitar MITM
########################################
# ** Redudante Sempgrep **
HOST_MATCH=$(safe_grep -E "HostnameVerifier" | grep -Ei "return true" || true)
if [[ -n "$HOST_MATCH" ]]; then
    append_report "$SAST_REPORTS_DIR/critical-hostnameverifier.txt" "$HOST_MATCH"
    echo "❌ MEDIUM: HostnameVerifier permissivo - Redudante Sempgrep"
    MEDIUM=$((MEDIUM+1))
fi

########################################
# 1.4 Hardcoded secrets
# MASVS-STORAGE-2 / OWASP M6
########################################
# ** Redudante Sempgrep **
HARD_SECRETS=$(safe_grep -E "AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|-----BEGIN [A-Z ]*PRIVATE KEY-----|client_secret|api_key|SECRET_KEY|JWT_SECRET")
if [[ -n "$HARD_SECRETS" ]]; then
    append_report "$SAST_REPORTS_DIR/critical-hardcoded-secrets.txt" "$HARD_SECRETS"
    echo "❌ MEDIUM: Hardcoded secrets - Redudante Sempgrep"
    MEDIUM=$((MEDIUM+1))
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
# ** Redudante Sempgrep **
REPORT_FILE="$SAST_REPORTS_DIR/high-http-urls.txt"
HTTP_URLS=$(safe_grep "http:\/\/[a-zA-Z0-9]")

SAFE_DOMAINS_REGEX='(schemas\.android\.com|w3\.org|purl\.org|apache\.org|openxmlformats.org|apple\.com)'

if [[ -n "$HTTP_URLS" ]]; then
    FILTERED_URLS=$(echo "$HTTP_URLS" | grep -vE "$SAFE_DOMAINS_REGEX" || true)

    if [[ -n "$FILTERED_URLS" ]]; then
        echo "$FILTERED_URLS" > "$REPORT_FILE"
        echo "⚠️ MEDIUM: HTTP inseguro detectado - Redudante Sempgrep"
        MEDIUM=$((MEDIUM+1))
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
ROOT_PATTERN='RootBeer|isDeviceRooted|isRooted|/system/xbin/su'

FOUND_ROOT=$(search_evidence "$ROOT_PATTERN" || true)
if [[ -n "$FOUND_ROOT" ]]; then
    append_report "$SAST_REPORTS_DIR/medium-root-checks.txt" "$FOUND_ROOT"
    echo "ℹ️ MEDIUM: Root detection presente — evidências abaixo:"
    echo "-----------------------------------------------------"
    echo "$FOUND_ROOT"
    echo "-----------------------------------------------------"
    MEDIUM=$((MEDIUM+1))
else
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
# ** Redudante Sempgrep **
WEAK_CRYPTO=$(safe_grep -E "MD5|SHA-1|SHA1" || true)
if [[ -n "$WEAK_CRYPTO" ]]; then
    append_report "$SAST_REPORTS_DIR/medium-weak-crypto.txt" "$WEAK_CRYPTO"
    echo "ℹ️ MEDIUM: uso de crypto fraca detectado - Redudante Sempgrep"
    MEDIUM=$((MEDIUM+1))
fi

########################################
# 3.3 Obfuscation (ou ausência)
# MASVS-RESILIENCE
########################################
OBF_PATTERN='proguard|minifyEnabled|R8|com.guardsquare'

OBF_FOUND=$(search_evidence "$OBF_PATTERN" || true)
if [[ -n "$OBF_FOUND" ]]; then
    append_report "$SAST_REPORTS_DIR/medium-obfuscation.txt" "$OBF_FOUND"
    echo "ℹ️ MEDIUM: Evidências de obfuscation encontradas:"
    echo "-----------------------------------------------------"
    echo "$OBF_FOUND"
    echo "-----------------------------------------------------"
    MEDIUM=$((MEDIUM+1))
else
    # fallback: checar configs Android e mapping.txt
    if grep -RIn --binary-files=without-match -E "minifyEnabled|proguardFiles|R8|com.guardsquare" apps/appbank/android 2>/dev/null | grep -q .; then
        append_report "$SAST_REPORTS_DIR/medium-obfuscation.txt" "Obfuscation configured in Android sources"
        echo "ℹ️ MEDIUM: Obfuscation configurada nas fontes Android — evidência:"
        grep -RIn --binary-files=without-match -E "minifyEnabled|proguardFiles|R8|com.guardsquare" apps/appbank/android 2>/dev/null | sed -n '1,200p'
        MEDIUM=$((MEDIUM+1))
    elif find apps/appbank -path "*/build/*/outputs/mapping/*/mapping.txt" -type f -print -quit 2>/dev/null | grep -q .; then
        append_report "$SAST_REPORTS_DIR/medium-obfuscation.txt" "mapping.txt found in build outputs — obfuscation likely enabled"
        echo "ℹ️ MEDIUM: mapping.txt presente — evidência (trecho):"
        find apps/appbank -path "*/build/*/outputs/mapping/*/mapping.txt" -type f -print -exec sed -n '1,50p' {} + 2>/dev/null | sed -n '1,200p'
        MEDIUM=$((MEDIUM+1))
    else
        append_report "$SAST_REPORTS_DIR/medium-obfuscation.txt" "No obfuscation indicators found"
        echo "⚠️ HIGH: Nenhuma evidência de obfuscation"
        HIGH=$((HIGH+1))
    fi
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
TARGET_RAW=$(get_project_target_sdk || true)
TARGET_SDK_NUM=$(echo "$TARGET_RAW" | grep -oE '[0-9]+' | head -n1 || true)

if [[ -n "$TARGET_SDK_NUM" ]]; then
    echo "✅ targetSdkVersion encontrado (fonte priorizada): $TARGET_SDK_NUM"
    echo "Evidência:"
    echo "-----------------------------------------------------"
    echo "$TARGET_RAW" | sed -n '1,200p'
    echo "-----------------------------------------------------"
    if (( TARGET_SDK_NUM < 34 )); then
        echo "❌ targetSdkVersion baixo ($TARGET_SDK_NUM) — recomenda-se atualizar para >=34"
        HIGH=$((HIGH+1))
    fi
else
    echo "⚠️ targetSdkVersion não encontrado — verifique android/app/build.gradle(.kts) ou AndroidManifest.xml."
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