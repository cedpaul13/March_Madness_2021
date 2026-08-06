#!/usr/bin/env bash
# Deploys the docs/ folder to the gh-pages branch so the website ships
# without its HTML source living on main. Run it after any site edit:
#
#   ./scripts/deploy_site.sh
#
# One-time setup on GitHub: Settings > Pages > Deploy from a branch >
# branch "gh-pages", folder "/ (root)".
#
# Unlike the 2026 site this copies the whole docs/ folder, because the
# 3D component view ships as pca3d.html plus its pca3d_files/ dependencies.
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
REMOTE="$(git -C "$ROOT" remote get-url origin)"
NAME="$(git -C "$ROOT" config user.name)"
EMAIL="$(git -C "$ROOT" config user.email)"

if [ ! -f "$ROOT/docs/index.html" ]; then
  echo "docs/index.html not found. Run Rscript R/run_all.R first." >&2
  exit 1
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cp -R "$ROOT/docs/." "$TMP/"
touch "$TMP/.nojekyll"
cd "$TMP"
git init -q -b gh-pages
git config user.name "$NAME"
git config user.email "$EMAIL"
git add -A
git commit -q -m "Deploy site $(date +%Y-%m-%d)"
git push -f "$REMOTE" gh-pages

echo "Deployed: https://cedpaul13.github.io/March_Madness_2021/"
