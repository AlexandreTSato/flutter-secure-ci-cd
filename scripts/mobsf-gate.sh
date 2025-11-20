#!/usr/bin/env bash
set -euo pipefail

REPORT="mobsfscan-report.json"
THRESHOLD_HIGH=0
THRESHOLD_CRITICAL=0

if [ ! -f "$REPORT" ]; then
  echo "❌ MobSF JSON report not found!"
  exit 1
fi

# dentro de scripts/mobsf-gate.sh (após carregar REPORT)
echo "🔎 Verificando MobSF por strings marcadas como secrets/hardcoded..."
# procura descrições que contenham keywords ou arquivos que contenham 'apikey' etc.
jq -r '.results[]? | to_entries[]? | (.value.files[]? .file_path // empty) + " :: " + ((.value.metadata.description // "") | gsub("\n";" "))' "$REPORT" 2>/dev/null \
  | grep -iE "api[_-]?key|secret|password|token|private key|aws|google|service_account" || true

# alternativa: procurar no JSON por cabeçalhos de chave PEM
if jq -r '..|strings' "$REPORT" 2>/dev/null | grep -i "-----BEGIN .*PRIVATE KEY-----" >/dev/null 2>&1; then
  echo "❌ Private key pattern found in MobSF report — treat as leak."
  exit 1
fi


# === Detecta formato e coleta severidades ===
HAS_RESULTS=$(jq 'has("results")' "$REPORT" 2>/dev/null || echo false)
if [ "$HAS_RESULTS" != "true" ]; then
  echo "⚠️ Unexpected MobSF JSON layout — showing first 100 lines"
  head -n 100 "$REPORT" || true
fi

# Contar quantos findings com severidade ERROR, WARNING, INFO
ERRORS=$(jq '[.results[]? | select(.metadata? and .metadata.severity=="ERROR")] | length' "$REPORT" 2>/dev/null || echo 0)
WARNINGS=$(jq '[.results[]? | select(.metadata? and .metadata.severity=="WARNING")] | length' "$REPORT" 2>/dev/null || echo 0)
INFOS=$(jq '[.results[]? | select(.metadata? and .metadata.severity=="INFO")] | length' "$REPORT" 2>/dev/null || echo 0)

echo "📊 MobSF summary: ERROR=$ERRORS | WARNING=$WARNINGS | INFO=$INFOS"

# === Listagem resumida dos achados ===
jq -r '.results | to_entries[] | [.key, .value.metadata.severity, (.value.metadata.masvs // "N/A"), (.value.metadata.description // "No desc")] | @tsv' "$REPORT" 2>/dev/null || true

# === Bloqueia se houver qualquer ERROR-level ===
if [ "$ERRORS" -gt "$THRESHOLD_CRITICAL" ]; then
  echo "❌ Blocking build: found $ERRORS ERROR-level findings (violations)."
  jq '.results | to_entries[] | select(.value.metadata.severity=="ERROR")' "$REPORT" || true
  exit 1
fi


# === Executa verificação de SSL Pinning complementar ===
if [ -x "./scripts/check-pinning-and-mobsf.sh" ]; then
  echo "🔎 Running SSL pinning correlation check..."
  ./scripts/check-pinning-and-mobsf.sh
  CODE=$?
  case "$CODE" in
    0)
      echo "✅ SSL Pinning check passed."
      ;;
    1)
      echo "❌ SSL Pinning check failed — blocking build."
      exit 1
      ;;
    2)
      echo "❌ SSL Pinning missing or uncertain — blocking build (manual review required)."
      exit 1
      ;;
    *)
      echo "⚠️ Unexpected exit code $CODE from SSL Pinning check — failing for safety."
      exit 1
      ;;
  esac
else
  echo "❌ check-pinning-and-mobsf.sh not found or not executable — blocking build."
  exit 1
fi


echo "✅ MobSF gate passed (no blocking findings)."
exit 0
