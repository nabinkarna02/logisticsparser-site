#!/usr/bin/env bash
# Run on the box AFTER `gh auth login` as nabinkarna02 (device flow: gh auth login --hostname github.com --git-protocol https --web)
set -euo pipefail
cd "$(dirname "$0")"
REPO=nabinkarna02/logisticsparser-site
gh repo view "$REPO" >/dev/null 2>&1 || gh repo create "$REPO" --public --description "logisticsparser.com one-page site" --source . --remote origin --push
git push -u origin main 2>/dev/null || true
# Enable Pages from main / root
gh api -X POST "repos/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" 2>/dev/null || echo "pages already enabled"
# Set custom domain (CNAME file also in repo)
gh api -X PUT "repos/$REPO/pages" -f cname=logisticsparser.com
gh api "repos/$REPO/pages"
echo "After DNS resolves and cert is issued:  gh api -X PUT repos/$REPO/pages -F https_enforced=true"
