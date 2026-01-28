# Documentation Platform Audit

This document summarizes the current state of the documentation platform powering developer.kivra.com.

## Current Stack

The documentation uses a combination of:
- **Redoc** (by Redocly) - Renders OpenAPI/Swagger specs as interactive docs
- **MDwiki** - Client-side markdown wiki for the receipt schema documentation
- **LogLive** - Client-side changelog renderer

## Version Status

| Component | Location | Current Version | Latest Version | Release Date | Age |
|-----------|----------|-----------------|----------------|--------------|-----|
| Redoc | `/index.html` | v2.0.0 | v2.5.2 | Sep 2022 | ~3.5 years |
| Redoc | `/receipt/posapi/` | v2.5.1 | v2.5.2 | Sep 2025 | ~4 months |
| Redoc | `/receipt/clientapi/` | `@next` | v2.5.2 | - | latest |
| LogLive | `/receipt/*/changelog/` | v0.2.3 | v0.2.3 | **Feb 2019** | **~7 years** |
| MDwiki | `/receipt/wiki/` | v0.6.2 | v0.7.0 | **May 2014** | **~11.5 years** |

## Dependency Health

| Component | Status | Notes |
|-----------|--------|-------|
| Redoc | :green_circle: Active | Actively maintained by Redocly. v3.0.0 in preview. Easy CDN upgrade. |
| LogLive | :orange_circle: Abandoned | Last release Feb 2019. No updates in ~7 years. |
| MDwiki | :red_circle: Effectively EOL | Last feature release 2014. v0.7.0 (2024) was just security fixes. Built on Bootstrap 3.0.0 and jQuery 1.8.3. |

## Recommendations

### 1. Redoc - Low effort fix

Update main `index.html` from v2.0.0 to latest CDN:

```html
<!-- Current -->
<script src="https://cdn.jsdelivr.net/npm/redoc@2.0.0/bundles/redoc.standalone.js"></script>

<!-- Recommended -->
<script src="https://cdn.redoc.ly/redoc/latest/bundles/redoc.standalone.js"></script>
```

The posapi version (v2.5.1) is already nearly current. The clientapi uses `@next` which auto-updates.

### 2. MDwiki - Consider migration

The wiki contains valuable receipt schema documentation (~10 markdown files) but is running on 11-year-old software with outdated dependencies (Bootstrap 3.0.0, jQuery 1.8.3).

**Modern alternatives:**
- **Docsify** - Similar client-side philosophy, actively maintained
- **MkDocs Material** - Python-based, very popular, great search
- **VitePress** - Vue-based, fast builds

The MDwiki content is just markdown files (`receipt/wiki/receipt-doc/`), so migration would mainly involve setting up a new renderer and adjusting navigation.

### 3. LogLive - Consider replacing

LogLive hasn't been updated since 2019. For simple changelog rendering, alternatives include:
- Embedding changelog in the Redoc spec description
- Using a simple marked.js setup
- Any of the MDwiki alternatives above

## File Structure

```
developer.kivra.com/
├── index.html                    # Redoc v2.0.0 → swagger.yml
├── swagger.yml                   # Main Kivra API spec
├── receipt/
│   ├── posapi/
│   │   ├── index.html            # Redoc v2.5.1 → posapi.yaml
│   │   ├── posapi.yaml           # POS/Receipts API spec
│   │   └── changelog/
│   │       ├── index.html        # LogLive v0.2.3
│   │       └── changelog.md
│   ├── clientapi/
│   │   ├── index.html            # Redoc @next → clientapi.json
│   │   ├── clientapi.json        # Client API spec
│   │   └── changelog/
│   │       ├── index.html        # LogLive v0.2.3
│   │       └── changelog.md
│   ├── wiki/
│   │   ├── mdwiki.html           # MDwiki v0.6.2 renderer
│   │   ├── index.md              # Wiki home
│   │   ├── navigation.md
│   │   └── receipt-doc/          # Markdown content (retail + prescription schemas)
│   └── schemas/
└── assets/
```
