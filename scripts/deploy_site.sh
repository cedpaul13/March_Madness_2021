#!/usr/bin/env bash
# Publishes docs/ to the gh-pages branch so the site ships without its HTML
# source living on main. Run it after any site edit:
#
#   ./scripts/deploy_site.sh
#
# One-time setup on GitHub: Settings > Pages > Deploy from a branch >
# branch "gh-pages", folder "/ (root)".
#
# Commits on top of existing gh-pages history without touching the main index.
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
REMOTE="$(git -C "$ROOT" remote get-url origin)"

for asset in index.html pca3d.html pca3d-table.html figures/biplot_combined.png figures/corrplot_combined.png; do
  if [ ! -s "$ROOT/docs/$asset" ]; then
    echo "Missing or empty site asset: docs/$asset. Restore the site files and run the pipeline before deploying." >&2
    exit 1
  fi
done

dependencies="$(sed -nE 's/.*(src|href)="(pca3d_files\/[^"]+)".*/\2/p' "$ROOT/docs/pca3d.html")"
if [ -z "$dependencies" ]; then
  echo "No 3D chart dependencies found in docs/pca3d.html." >&2
  exit 1
fi
while IFS= read -r asset; do
  if [ ! -s "$ROOT/docs/$asset" ]; then
    echo "Missing or empty 3D chart dependency: docs/$asset" >&2
    exit 1
  fi
done <<< "$dependencies"

remote_ref="$(git ls-remote --heads "$REMOTE" refs/heads/gh-pages)"
parent=""
if [ -n "$remote_ref" ]; then
  git -C "$ROOT" fetch --quiet --no-tags "$REMOTE" refs/heads/gh-pages
  parent="$(git -C "$ROOT" rev-parse FETCH_HEAD)"
fi

INDEX="$(mktemp "${TMPDIR:-/tmp}/mm21-index.XXXXXXXX")"
trap 'rm -f -- "$INDEX"' EXIT
rm -f -- "$INDEX"
export GIT_INDEX_FILE="$INDEX"
git -C "$ROOT" read-tree --empty
git -C "$ROOT/docs" --work-tree="$ROOT/docs" add -f -A -- .
empty_blob="$(git -C "$ROOT" hash-object -w --stdin </dev/null)"
git -C "$ROOT" update-index --add --cacheinfo 100644 "$empty_blob" .nojekyll
tree="$(git -C "$ROOT" write-tree)"

if [ -n "$parent" ] && [ "$tree" = "$(git -C "$ROOT" rev-parse "$parent^{tree}")" ]; then
  echo "Site is already up to date; nothing to deploy."
  exit 0
fi

if [ -n "$parent" ]; then
  commit="$(git -C "$ROOT" commit-tree "$tree" -p "$parent" -m "Deploy site $(date '+%Y-%m-%d %H:%M')" -m "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>")"
else
  commit="$(git -C "$ROOT" commit-tree "$tree" -m "Deploy site $(date '+%Y-%m-%d %H:%M')" -m "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>")"
fi
git -C "$ROOT" push --quiet "$REMOTE" "$commit:refs/heads/gh-pages"

echo "Deployed: https://cedpaul13.github.io/March_Madness_2021/"
echo "Commit:   $commit on gh-pages"
