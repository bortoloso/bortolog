# BORTO.LOG

## TL;DR

BORTO.LOG é um blog pessoal técnico construído com Hugo e o tema PaperMod, hospedado no Cloudflare Pages. Aqui eu documentei o setup inicial, a arquitetura da stack e o fluxo de trabalho que uso para escrever, testar e publicar posts.

## Sobre o blog

Este repositório contém o site do blog BORTO.LOG.
O objetivo principal é:

- aprender mais e praticar tecnologias que não uso com frequência
- documentar o cotidiano de desenvolvimento e infraestrutura
- escrever sobre assuntos que acho relevantes
- registrar experimentos, curiosidades e descobertas técnicas
- ter um lugar para anotações, tutoriais e processos de estudo

A ideia é que este blog seja um caderno técnico vivo, onde cada post pode ser uma nota de trabalho, um tutorial ou um registro de algo que surgiu no dia a dia.

## Stack

- Hugo como gerador de site estático
- Tema PaperMod
- GitHub para versionamento
- Cloudflare Pages para deploy automático e CDN global

## Links

- Blog: https://bortoloso.me
- Post de setup inicial: `content/posts/setup-inicial/index.md`

## Conteúdo importante

O primeiro post do blog (`setup-inicial`) documenta o processo inicial de configuração e as decisões importantes para este projeto. Ele também traz os comandos para rodar localmente e preparar o build.

## Como rodar localmente

1. Clone o repositório:

```bash
git clone https://github.com/bortoloso/bortolog.git
cd bortolog
```

2. Inicialize os submódulos (tema PaperMod é submódulo):

```bash
git submodule update --init --recursive
```

3. Inicie o servidor de desenvolvimento (inclui drafts):

```bash
hugo server -D
```

4. Inicie o servidor de desenvolvimento com um ambiente específico (opcional):

```bash
hugo server -D --environment staging
# ou
hugo server -D --environment production
```

5. Acesse no navegador:

```text
http://localhost:1313
```

6. Criar um novo post como Page Bundle usando o archetype `archetypes/index.md`:

```bash
./new-post.sh "meu-post-slug"
# cria content/posts/meu-post-slug/index.md usando o archetype index
```

Coloque imagens e outros recursos dentro da pasta do post (ex: `content/posts/meu-post-slug/`).

## Como gerar o site para produção (e staging)

1. Build para produção:

```bash
hugo --environment production --gc --minify
```

2. Build para staging:

```bash
hugo --environment staging --gc --minify
```

O site gerado ficará em `public/`.

Para testar a versão gerada localmente:

```bash
cd public
python3 -m http.server 8000
```

E acesse:

```text
http://localhost:8000
```

3. Observações sobre deploy (Cloudflare Pages):

- Branch `main` → build com `--environment production`
- Branch `staging` → build com `--environment staging`
- Outros branches → build falha intencionalmente (proteção contra deploys acidentais)

Exemplo do comando de build usado pelo Cloudflare Pages (script shell precisa ser em uma linha Cloudflare remove quebras de linha):

```bash
git submodule update --init --recursive && echo "Branch=$CF_PAGES_BRANCH"; if [ "$CF_PAGES_BRANCH" = "main" ]; then echo "ENV=production"; hugo --environment production --gc --minify; elif [ "$CF_PAGES_BRANCH" = "staging" ]; then echo "ENV=staging"; hugo --environment staging --gc --minify; else echo "ERROR: unsupported branch '$CF_PAGES_BRANCH'"; exit 1; fi
```

## Notas de deploy

O deploy do blog é feito no Cloudflare Pages. A configuração de build recomendada é:

- Branch: `main`
- Build command: `git submodule update --init --recursive && hugo --gc --minify`
- Output directory: `public`

## Observações

- O tema PaperMod está configurado como submódulo Git em `themes/PaperMod`.
- O arquivo `hugo.toml` contém a configuração principal do site, incluindo `baseURL`, idioma, taxonomias e parâmetros do tema.
- O conteúdo do primeiro post e o tutorial de setup são um guia inicial para entender como o blog foi montado.

## Licenças

- **Conteúdo** (posts, textos, imagens): [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
- **Código** (templates, configurações): [MIT](LICENSE)