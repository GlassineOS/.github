#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# install-hooks.sh [REPO]: install the GlassineOS safety-scan as pre-commit and pre-push
# hooks in REPO (default: the current repository). The hooks call this checkout's
# safety-scan.sh, so keep the .github checkout where it is.
set -eu
scan=$(cd "$(dirname "$0")" && pwd)/safety-scan.sh
repo=${1:-.}
hooks=$(git -C "$repo" rev-parse --git-path hooks)
case $hooks in /*) ;; *) hooks=$(cd "$repo" && pwd)/$hooks ;; esac
mkdir -p "$hooks"
for h in pre-commit pre-push; do
  [ -e "$hooks/$h" ] && ! grep -q safety-scan "$hooks/$h" && { echo "$hooks/$h exists, not overwriting" >&2; continue; }
  case $h in
    pre-commit) arg=--staged ;;
    pre-push) arg=--pre-push ;;
  esac
  printf '#!/bin/sh\nexec "%s" %s\n' "$scan" "$arg" > "$hooks/$h"
  chmod +x "$hooks/$h"
  echo "installed $hooks/$h"
done
