# CUSP Urban Observatory

[![Deploy Site](https://github.com/CUSPUO/cuspuo.github.io/actions/workflows/deploy.yml/badge.svg)](https://github.com/CUSPUO/cuspuo.github.io/actions/workflows/deploy.yml)
[![Terraform](https://github.com/CUSPUO/cuspuo.github.io/actions/workflows/terraform.yml/badge.svg)](https://github.com/CUSPUO/cuspuo.github.io/actions/workflows/terraform.yml)

The public website for the CUSP Urban Observatory.

**Live at:** [cuspuo.org](https://cuspuo.org) | [cuspuo.com](https://cuspuo.com)

## Editing the Site

The site is static HTML. To make changes:

1. Edit the relevant files (see [File Structure](#file-structure) below)
2. Commit and push to the `master` branch (or open a PR and merge it)
3. The site automatically deploys within ~1 minute

No build step, no manual deployment — just edit, push, and it's live.

## How Deployment Works

When changes are pushed to `master`:

1. **Sync** — All site files are uploaded to an S3 bucket
2. **Cache clear** — CloudFront CDN cache is invalidated
3. **Live** — Changes are available on all domains (cuspuo.org, cuspuo.com, and their www variants)

HTML files are cached for 5 minutes; other assets (images, CSS, JS) are cached for 24 hours.

## File Structure

```
index.html                  Main site page
UOpublications.html         Publications listing
404.html                    Custom error page
comingsoon.html             Placeholder page
images/                     Team photos and site images
assets/                     CSS, JavaScript, and fonts
projects/                   Project sub-pages (cdrhythms, visim_energy, etc.)
bibtex2html/                Tool to convert BibTeX to HTML (see its own README)
uo.bib                      BibTeX source for publications
```

## Updating Publications

Publications are generated from `uo.bib` using the `bibtex2html/` tool:

```bash
cd bibtex2html
python bibtex2html_p3.py ../uo.bib template.html ../UOpublications.html
```

See [`bibtex2html/README.md`](bibtex2html/README.md) for details.

## Infrastructure

The site is hosted on AWS (S3 + CloudFront) and managed with Terraform. See [`infra/README.md`](infra/README.md) for architecture, setup, and operational details.
