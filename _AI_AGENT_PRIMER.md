# AI Agent Primer — FuckPicRights.com

Read this before touching the repo.

## What this project is

A single-page static website archiving a real 2019–2020 email exchange between
Ziad Ezzat and the copyright-troll firm PicRights (Geoff Beal, acting for AFP
then the Associated Press). The site is documentary/satire: it warns people not
to pay copyright-troll shakedowns when they've done nothing seriously wrong, and
to consult a real attorney if they have. It was rebuilt from a saved WordPress
/Elementor page into hand-authored HTML + SCSS.

## The one rule that matters most

**The correspondence is verbatim.** Every email and the FAQ are reproduced
exactly — original typos, double spaces, smart quotes, the Nigerian-prince bit,
the lot. Do not "fix," reword, or clean up any of the quoted content. The
authoritative source is `_archive/wordpress-capture/`. If you need to re-verify
wording, extract text from that saved HTML (e.g. `textutil -convert txt`).

Hero tagline, footer, and section chrome are the only non-verbatim copy, and
they should stay clearly distinct from the correspondence.

## Stack & conventions

- **No framework, no SSG, no runtime JS dependency.** Plain `index.html` + one
  compiled `style.css`. A tiny inline progressive-enhancement script handles the
  accordion "Next" buttons, the live FAQ date, and the back-to-top button; the
  page works fully without it (entries are native `<details>`).
- **Styles:** SCSS in `scss/`, compiled with Dart Sass via `npx sass`
  (never via an IDE extension). Partials use `@use`. Entry point is
  `scss/main.scss`.
- **Colors:** only the variables defined in `scss/_variables.scss` are used —
  the `ziad.ezzat.com` palette plus the logo's red/green. Don't introduce ad-hoc
  hex values.
- **Media queries:** each `@media` block is preceded by a `//@ Label` comment.
- **Fonts:** Inter is self-hosted as a variable woff2 in `assets/fonts/`
  (one file spans weights 100–900). No CDN — the site must work offline.

## Layout model

The thread is a `<ol class="thread">` of 11 `<li class="entry">` nodes (FAQ +
10 emails). Each entry:

- carries `entry--ziad` (blue accent) or `entry--troll` (graphite accent), which
  sets `--accent` used by the spine dot, card border, and tag;
- has a `.entry__marker` (spine dot + date) that sits in a left gutter on wide
  screens and collapses to a chip above the card on mobile;
- is a `<details class="entry__card">` (collapsed by default; FAQ is `open`)
  with a `<summary class="entry__head">` (tag + title + chevron) and an
  `.entry__body` holding the `.email` block — optional `.email__letterhead`
  (sender/client logos), an `.email__meta` From/To/Subject header, a `.prose`
  body, optional `.evidence` (DETAILS) image pairs — and a `.entry__next` button.

The "Next" button collapses the current entry and opens the next; the last one
becomes "Back to top." That wiring is automatic (the script keys off DOM order).

To add an entry: clone an existing `<li>`, give it a unique `id`, and tag it
ziad/troll.

## Build / run / deploy

```bash
npx sass scss/main.scss style.css --style=compressed --no-source-map  # build
python3 -m http.server 4317                                           # serve
docker compose up -d --build                                          # container :4317
```

Deploy is Docker-on-NAS (Archetype A): `./utils/deploy/prod.sh` builds the image
locally, ships it to the Synology NAS over SSH, and runs it via `docker-compose`
(reverse proxy fronts the container on port 4317). `docker-compose.yml` uses
`image: fuckpicrights:latest` — the NAS gets the prebuilt image, not the source.
`utils/deploy/deploy-utils.sh` handles logs/status/restart. SFTP of
`index.html` + `style.css` + `assets/` also works if you ever want it.

## Gotchas

- `.gitignore` ignores `*.css` (generic boilerplate) but has an explicit
  `!/style.css` exception so the compiled stylesheet ships. Keep that exception.
- `_archive/`, `*.ai`, and `*.psd` are gitignored by design (source material,
  not build output).
- Evidence image filenames in `assets/evidence/` map to the email DETAILS blocks
  by document order; catalog images are named after their catalog numbers.
