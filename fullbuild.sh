#!/bin/bash
set -e  # faz o script parar se qualquer comando falhar

echo "🚀 Iniciando setup..."

cd "$(dirname "$0")"

echo "🧹 Limpando workspaces com Melos Clean..."
melos clean

echo "🧱 Rodando Melos Bootstrap..."
melos bootstrap

echo "🚀 Dart Fix..."
dart fix --apply

echo "🚀 Dart Format..."
dart format .

echo "🚀 Dart Analyze..."
melos analyze

echo "🚀 Melos Test..."
melos test

echo "🏗️ Gerando build Flutter..."
cd apps
cd appbank
flutter build apk --release

echo "✅ Tudo concluído com sucesso!"
