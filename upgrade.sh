#!/bin/sh
# Rebase our custom commits onto the latest Dolibarr production release.
# Usage: ./upgrade.sh [tag]   (default: latest GitHub release)
set -e
cd "$(dirname "$0")"
cur=$(git describe --tags --abbrev=0)
new=${1:-$(curl -s https://api.github.com/repos/Dolibarr/dolibarr/releases/latest | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')}
[ "$cur" = "$new" ] && { echo "already on $new"; exit 0; }
git fetch --depth 1 upstream tag "$new" --no-tags
git rebase --onto "$new" "$cur"
echo "$cur -> $new. Deploy, then run htdocs/install/upgrade on each instance."
