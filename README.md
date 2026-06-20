# FuckPicRights.com

A single-page static site that archives a 2019–2020 email exchange between
Ziad Ezzat and "Geoff Beal," a compliance officer at the copyright-troll firm
PicRights (acting for AFP, then the Associated Press). It exists as a public
warning: if you've done nothing seriously wrong, don't fold to these scammers;
if you've actually infringed someone's copyright, get a lawyer.

It's a resurrection of the original WordPress/Elementor page as a clean,
self-contained static site — same name, same logo, the `ziad.ezzat.com` palette
and Raleway typography, rebuilt as a dossier-style timeline.

## What's in here

| Path | Purpose |
| ---------------- | ------------------------------------------------------------ |
| `index.html` | The whole site. All correspondence is verbatim. |
| `scss/` | Source styles (compiled to `style.css`). |
| `style.css` | Compiled stylesheet — committed so the site needs no build to deploy. |
| `assets/` | Logo, favicons, self-hosted Raleway fonts, sender logos, evidence images. |
| `Dockerfile` | Multi-stage build (compiles SCSS, serves via nginx). |
| `nginx.conf` | Static-server config used by the Docker image. |
| `docker-compose.yml` | One-command local/NAS container on port 4317. |
| `_archive/` | The original WordPress capture and source brand art (gitignored). |

## Local development

The only tool needed is [Dart Sass](https://sass-lang.com/) via `npx`.

Build the stylesheet once:

```bash
npx sass scss/main.scss style.css --style=compressed --no-source-map
```

Or watch while editing styles:

```bash
npx sass --watch scss/main.scss style.css
```

Serve the folder locally (any static server works):

```bash
python3 -m http.server 4317
# then open http://localhost:4317
```

`npm run build`, `npm run dev`, and `npm run serve` wrap the commands above.

## Deploying

The site is plain static files with no runtime dependency. Two paths, both
serving the identical folder:

### Option A — SFTP / static upload

1. Build the stylesheet: `npx sass scss/main.scss style.css --style=compressed`.
2. Upload to the web root. You only need `index.html`, `style.css`, and
   `assets/`. You can skip `scss/`, `_archive/`, `node_modules/`, and the
   project meta files.

### Option B — Docker on the NAS (production)

This is the real deploy path. `utils/deploy/prod.sh` builds the image locally
(`linux/amd64`), ships it to the Synology NAS over SSH, and brings the container
up via `docker-compose`. Front it with your reverse proxy pointed at the
container (host port `4317`).

```bash
./utils/deploy/prod.sh            # build → transfer → up -d (prompts to confirm)
./utils/deploy/prod.sh --dry-run --force   # preview without doing anything
./utils/deploy/deploy-utils.sh logs        # follow logs / status / restart
```

The prod gate requires a clean working tree on `main` (bypass with `--force`).
`docker-compose.yml` references `image: fuckpicrights:latest` (built and loaded
by the script), not a build context — so the NAS never needs the source.

To test the container locally before deploying:

```bash
docker build -t fuckpicrights:latest . && docker compose up
# serves on http://localhost:4317
```

## Editing the content

All emails and the FAQ are stored as literal HTML inside `index.html`, kept
**verbatim** — original typos, spacing, and smart quotes included. If you add a
new entry, copy an existing `<li class="entry …">` block, give it a unique `id`,
add a matching link in the `<nav class="toc">` list, and tag it
`entry--ziad` or `entry--troll` to set its accent color.

## Notes

- **Fonts are self-hosted** (`assets/fonts/`), so the site works offline / on a
  LAN with no Google Fonts CDN call.
- **`.gitignore` ignores `*.css`** (a generic convention) but makes an explicit
  exception for `/style.css` so the compiled stylesheet ships with the repo.
- The original capture lives in `_archive/` as the source of truth for the
  verbatim text. It's gitignored but remains in the initial commit's history.
