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

2. Inicialize os submódulos:

```bash
git submodule update --init --recursive
```

3. Inicie o servidor de desenvolvimento Hugo:

```bash
hugo server -D
```

4. Acesse no navegador:

```text
http://localhost:1313
```

## Como gerar o site para produção

No repositório, rode:

```bash
hugo --gc --minify
```

O site gerado ficará em `public/`.

Para testar a versão de produção localmente:

```bash
cd public
python3 -m http.server 8000
```

E acesse:

```text
http://localhost:8000
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