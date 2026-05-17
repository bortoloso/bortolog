# AGENTS.md - BORTO.LOG

## Quick facts
- Hugo static site with PaperMod theme
- Hosted on Cloudflare Pages (not GitHub Pages)
- Language: Portuguese (pt-BR)

## Commands

```bash
# Dev server (includes drafts, uses _default config)
hugo server -D
# Access: http://localhost:1313

# Dev server with production environment
hugo server -D --environment production

# Dev server with staging environment
hugo server -D --environment staging

# Create new post (Page Bundle)
./new-post.sh "my-post-slug"
# Or: hugo new posts/my-post-slug/index.md

# Build for local testing (uses _default config)
hugo --gc --minify

# Build production environment locally
hugo --environment production --gc --minify

# Build staging environment locally
hugo --environment staging --gc --minify

# Test build locally
cd public && python3 -m http.server 8000

# Update theme submodule
git submodule update --init --recursive
```

## Config environments

This project uses Hugo's environment system with three configuration levels:

### `config/_default/` - Base configuration
- Shared by both staging and production
- Contains: menu structure, theme settings, global parameters, taxonomies
- No baseURL (inherited by child environments)
- Used for local development when running `hugo server -D`

### `config/staging/` - Staging environment
- `baseURL = "https://staging.bortoloso.me/"`
- Preview and testing before production

### `config/production/` - Production environment
- `baseURL = "https://bortoloso.me/"`
- `params.analytics.google` enabled
- Full indexing and public serving

## Cloudflare Pages build

**Branches configured:**
- `main` → builds with `--environment production`
- `staging` → builds with `--environment staging`
- Other branches → build fails explicitly

**Build command:**
```bash
git submodule update --init --recursive && echo "Branch=$CF_PAGES_BRANCH"; if [ "$CF_PAGES_BRANCH" = "main" ]; then echo "ENV=production"; hugo --environment production --gc --minify; elif [ "$CF_PAGES_BRANCH" = "staging" ]; then echo "ENV=staging"; hugo --environment staging --gc --minify; else echo "ERROR: unsupported branch '$CF_PAGES_BRANCH'"; exit 1; fi
```

**Output directory:** `public`

This ensures:
- Production builds happen only from `main`
- Staging builds happen only from `staging`
- No accidental deploys from feature branches
- Clear separation of environments

## Post front matter (required fields)
```yaml
---
title: "Title"
date: 2026-05-15
draft: false
slug: "url-slug"
description: "SEO description"
tags: ["tag1", "tag2"]
categories: ["dev"]
# Optional: series, showToc, cover.image, etc.
---
```

## Post structure
- Posts live in `content/posts/<slug>/index.md`
- Images go in the same folder: `content/posts/<slug>/cover.png`
- Use Page Bundle format (index.md with folder)
- Publish with `draft: false` - drafts ignored in production/staging (only shown locally with `-D` flag)
- Link to edit post: GitHub link auto-generated via `params.editPost` in config

## Commit conventions

Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) for all commit messages.

**Commit messages must always be in English**, even though the blog content is in Portuguese (pt-BR).

**Format:**
```
<type>(<scope>): <subject>

[optional body with detailed explanation]
```

**Subject line:**
- Imperative mood ("add" not "added" or "adds")
- Don't capitalize first letter
- No period (.) at the end
- Max 50 characters

**Body (optional but recommended):**
- Add one or more paragraphs when the change warrants detailed explanation
- Wrap at 72 characters
- Explain the **what** and **why**, not the how
- Separate subject and body with a blank line

**Common types:**
- `feat:` new feature or content
- `fix:` bug fix or correction
- `docs:` documentation update
- `chore:` config, dependency updates, or maintenance
- `refactor:` code restructuring without changing behavior
- `style:` formatting, whitespace, missing semicolons (non-code changes)

**Examples:**

Simple commit (no body needed):
```
feat(blog): add about page
```

Commit with detailed body:
```
docs(agents): document environment-based config

This project now uses Hugo's environment system to separate
staging and production builds. Added detailed documentation
about config/_default/, config/staging/, and config/production/
directories.

Also documented the Cloudflare Pages build command that uses
branch-based logic to ensure production and staging builds
happen only on their respective branches.
```

Another example:
```
fix(giscus): resolve theme sync issue

The Giscus comments widget was not responding to PaperMod's
dark/light theme toggle. Fixed by implementing a custom partial
at layouts/partials/comments.html that monitors localStorage
and sends postMessage updates to the iframe.

Verified in both X11 and Wayland environments.
```

## Gotchas
- Theme is a git submodule - must init before build (`git submodule update --init --recursive`)
- `buildDrafts = false` in config - remove `draft: true` before publishing
- Giscus comments sync with dark/light theme via custom partial at `layouts/partials/comments.html`
- Code highlighting uses Chroma (native), not highlight.js - classes enabled
- JSON output required for Fuse.js search - `outputs.home = ["HTML", "RSS", "JSON"]`

## Key files
- `config/_default/hugo.toml` - shared base configuration
- `config/staging/hugo.toml` - staging-specific overrides
- `config/production/hugo.toml` - production-specific overrides
- `new-post.sh` - post creation script
- `content/posts/setup-inicial/index.md` - full setup documentation
- `content/sobre/index.md` - about page
- `layouts/partials/comments.html` - Giscus integration
- `layouts/partials/extend_head.html` - custom head tags and favicons