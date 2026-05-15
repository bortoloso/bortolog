---
title: "Setup inicial: Hugo + PaperMod + GitHub + Cloudflare Pages"
date: 2026-05-15
lastmod: 2026-05-15
draft: false
slug: "setup-inicial"
description: "Documentação do processo inicial de configuração do blog BORTO.LOG: Hugo, PaperMod, GitHub e Cloudflare Pages."
tags: ["hugo","papermod","cloudflare","deploy","git","setup"]
categories: ["infra","dev"]
---

Este post documenta, passo a passo, como configurei o blog BORTO.LOG até o momento. Serve como referência para mim e para quem quiser reproduzir a mesma stack: Hugo + tema PaperMod, versionado no GitHub, publicado via Cloudflare Pages.

Sumário rápido
- Propósito e decisão da stack
- Pré-requisitos
- Estrutura do repositório e convenções
- Comandos para desenvolvimento local
- Configuração do build e deploy no Cloudflare Pages
- Dicas e pendências

**Propósito**

Criei este blog como um caderno técnico pessoal: anotações, tutoriais, experimentos e documentação do meu dia a dia como engenheiro/desenvolvedor. Precisei de algo rápido para gerar HTML estático, com suporte a temas modernos, boa performance e sem dependências pesadas, por isso escolhi Hugo =)... e por outras razões pessoais.

Por que Hugo + PaperMod + Cloudflare Pages
- Hugo: binário único, build muito rápido, sistema de Page Bundles e suporte a processamento de imagens. Quando usar SCSS/asset pipeline, prefira a versão Extended.
- PaperMod: tema minimalista, suporte a dark/light, busca client-side com Fuse.js, muitas convenções prontas para blogs técnicos.
- Cloudflare Pages: CDN global, deploy por push no GitHub, preview por PR e plano gratuito com SSL automático.

Pré-requisitos
- Git (com suporte a submódulos)
- Conta no GitHub com repositório público (ou privado com Pages/Cloudflare configurado)
- Conta no Cloudflare
- Hugo (recomendo a versão latest ou especificar `HUGO_VERSION` no Pages)
- Opcional: Hugo Extended (se usar SCSS ou processamento avançado de imagens)

Estrutura do repositório (resumo)

```
.
├── archetypes/
├── content/
│   └── posts/
├── layouts/
├── static/
├── themes/
│   └── PaperMod/    # submódulo git
├── hugo.toml
└── .gitignore
```

Principais configurações no `hugo.toml` que uso neste projeto
- `baseURL = "https://bortoloso.me/"`
- `theme = "PaperMod"`
- `defaultContentLanguage = "pt"`
- `outputs.home = ["HTML","RSS","JSON"]` (JSON necessário para busca via Fuse.js)
- `pygmentsUseClasses = true` e `markup.highlight.noClasses = false` para usar Chroma
- `[params].env = "production"` para ativar metatags sociais do PaperMod

Submódulo do tema

O tema PaperMod está como submódulo Git (`themes/PaperMod`), mantido por `.gitmodules`. No ambiente de build precisamos inicializá-lo.

Comandos úteis — desenvolvimento local

- Iniciar servidor de dev (hot reload):

```bash
hugo server -D
# Acesse: http://localhost:1313
```

- Criar um novo post (uso o script `new-post.sh` ou o archetype do Hugo):

```bash
./new-post.sh nome-do-post
# ou
hugo new posts/nome-do-post/index.md
```

- Atualizar submódulos localmente (quando clonar o repo):

```bash
git submodule update --init --recursive
```

- Build de produção (gera `public/`):

```bash
hugo --gc --minify
```

- Testar o `public/` localmente (servidor simples):

```bash
cd public
python3 -m http.server 8000
# Acesse: http://localhost:8000
```

Configuração recomendada para Cloudflare Pages

No painel do Cloudflare Pages, ao criar o projeto conectado ao GitHub, use estas opções:

- Branch: `main`
- Build command:

```bash
git submodule update --init --recursive && hugo --gc --minify
```

- Output directory: `public`

Variáveis de ambiente úteis (opcionais):
- `HUGO_VERSION` — definir a versão do Hugo para tornar o build reprodutível
- Se usar Extended: definir `HUGO_VERSION` para uma versão Extended disponível na imagem

Porque esse comando?
- `git submodule update --init --recursive` garante que o tema PaperMod (submódulo) esteja disponível durante o build.
- `hugo --gc --minify` gera o site otimizado e pronto para entrega.

Domínio customizado e SSL

No Cloudflare Pages, adicione o domínio `bortoloso.me` (você usa o seu, esse é meu hehe) como custom domain no projeto Pages. O Cloudflare gerencia o SSL automaticamente. Se necessário, aponte os registros DNS conforme instruções do Pages (geralmente CNAME/ALIAS apontando para o domínio do Pages).

Observações sobre `site.webmanifest` e favicons

Coloque todos os ícones gerados (p.ex. pelo RealFaviconGenerator) dentro de `static/` e referencie-os em `layouts/partials/extend_head.html` (já feito neste projeto). Verifique que os arquivos referenciados em `static/site.webmanifest` existam em `static/`.

`.gitignore` e arquivos a não versionar

Recomendo ignorar a saída de build e caches:

```
/public/
/resources/
hugo_stats.json
node_modules/
.cache/
.env*
```

Importante: não ignore `themes/PaperMod` se você converter o submódulo em diretório, mas mantenha-o como submódulo se quiser acompanhar upstream do PaperMod.

Fluxo de publicação (resumido)

1. Criar/editar post localmente (usar `hugo server -D` para validar).
2. Confirmar `draft: false` no front matter quando pronto.
3. Commit e push para `main`:

```bash
git add .
git commit -m "post: setup inicial"
git push origin main
```

4. O Cloudflare Pages detecta o push, executa o build e publica o site automaticamente.

Notas e decisões importantes que tomei

- Usei `archetypes/posts/index.md` e o script `new-post.sh` para acelerar criação de posts.
- Preferi não usar GitHub Pages: Cloudflare Pages oferece CDN global com preview e builds rápidos.
- Mantive `env = "production"` no `hugo.toml` para ter metadados sociais corretos.
- Optei por `pygmentsUseClasses = true` e `disableHLJS = true` para usar Chroma, evitando JS extra para highlight.

Pendências e próximos passos

- Gerar e incluir favicons completos via RealFaviconGenerator e confirmar caminhos em `params.assets`.
- Verificar se o build do Cloudflare está usando Hugo Extended (se precisar de processamento SCSS/ imagens responsivas).
- Avaliar adicionar `CNAME` ou configuração de DNS definitiva para `bortoloso.me` quando o domínio estiver pronto.
- Considerar habilitar `ShowShareButtons` ou sistema de comentários (Giscus) se desejar interação.

Se quiser, eu posso:
- adicionar um arquivo `README.md` com instruções de deploy automático para Cloudflare Pages;
- transformar o submódulo em cópia direta do tema (se preferir evitar submódulos);
- criar o `CNAME` no repositório `public/` caso prefira gerenciar DNS via Git.
- Principalmente, validar este post... porque escrevi ele mas especificamente este projeto mesmo ainda não foi nem commitado, nem incluído no cloudflare pages, então é um YOLO de post que vou atualizar depois... só os fortes verão isso pq vou atualizar o post depois.

---
Publicado em 2026-05-15 — Borto
