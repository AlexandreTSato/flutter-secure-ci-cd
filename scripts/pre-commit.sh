#!/usr/bin/env bash

# Ajustar PATH no Git Bash (Windows)
export PATH="$HOME/.pub-cache/bin:$PATH"
export PATH="/c/Users/Usuario/AppData/Local/Pub/Cache/bin:$PATH"

#C:\Users\Usuario\AppData\Local\Pub\Cache\bin

echo "🔍 Executando pre-commit: format + analyze + test rápido com path..."

# Garante ambiente consistente
melos bootstrap > /dev/null

# 1. Formatação automática
melos run format:fix

# 2. Análise estática
melos run analyze

# 3. Teste rápido (só pacotes críticos)
#melos exec --scope="app|pix|shared" -- flutter test --no-pub --coverage
melos exec --scope="pix" -- flutter test --no-pub --coverage

if [ $? -ne 0 ]; then
  echo "❌ Commit bloqueado: falhas encontradas."
  exit 1
else
  echo "✅ Tudo certo! Pode commitar 🚀"
fi
