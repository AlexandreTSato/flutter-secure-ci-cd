#!/usr/bin/env bash
set -euo pipefail

echo "🔐 Running CI secret scanning: detect-secrets + gitleaks"

# 1) detect-secrets scan using baseline (fails on new secrets)
if command -v detect-secrets >/dev/null 2>&1; then
  echo "-> detect-secrets: scanning with baseline"
  detect-secrets scan --baseline .secrets.baseline || {
    echo "❌ detect-secrets detected new secrets. See output above."
    exit 1
  }
else
  echo "⚠️ detect-secrets not installed. Skipping (install as pre-req)."
fi

# 2) gitleaks (fast repository scan)

#regras no arquivo TOML
#Pode expandir com mais regras (Twilio, Stripe, Slack tokens, etc.). gitleaks tem muitas regras built-in, o arquivo adiciona/overrides.

if command -v gitleaks >/dev/null 2>&1; then
  echo "-> gitleaks: scanning repository"
  # CORREÇÃO AQUI: Trocado --config-path por --config
  gitleaks detect --source . --report-path gitleaks-report.json --config .gitleaks.toml || {
    echo "❌ gitleaks found potential leaks. See gitleaks-report.json"
    jq . gitleaks-report.json || true
    exit 1
  }
else
  echo "⚠️ gitleaks not installed. Skipping."
fi

echo "✅ CI secret scanning passed."
exit 0