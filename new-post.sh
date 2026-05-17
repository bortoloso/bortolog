#!/usr/bin/env bash
# new-post.sh - cria um novo post como Page Bundle
# Uso: ./new-post.sh "meu-post-sobre-algo"
# Com prefixo numérico para series: ./new-post.sh "git-01-conceitos-basicos"

set -e

if [ -z "$1" ]; then
  echo "Uso: $0 <slug-do-post>"
  echo "Exemplo: $0 configurando-wsl2"
  exit 1
fi

SLUG="$1"

hugo new --kind index "posts/${SLUG}/index.md"

echo ""
echo "✅ Post criado em: content/posts/${SLUG}/index.md"
echo "📁 Coloca imagens em: content/posts/${SLUG}/"
echo "🚀 Para visualizar: hugo server -D"