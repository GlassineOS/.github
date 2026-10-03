#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-or-later
#
# safety-scan.sh: keep vendor binaries, device dumps, keys and personal data out of
# GlassineOS repositories.
#
#   safety-scan.sh --staged          files staged for the next commit (pre-commit)
#   safety-scan.sh --range A..B      every blob added in the commits A..B
#   safety-scan.sh --pre-push        reads the pre-push hook's stdin, scans what is pushed
#   safety-scan.sh --all             every blob in the whole history, all refs
#
# Exit status 1 if anything is flagged. Per-repository rules in .safety-scan at the
# repository root (one rule per line, '#' comments):
#   allow-path <glob>     never flag files matching this path glob
#   deny-path <glob>      flag files matching this path glob
#   deny-re <regex>       flag files whose content matches (grep -E)
#   max-size <bytes>      size limit (default 5242880)
set -u

MAX_SIZE=5242880
DENY_PATHS=(
  '*.wbf' '*.bin' '*.BIN' '*.img' '*.elf' '*.mbn' '*.mdt' '*.b[0-9][0-9]'
  '*.so' '*.so.*' '*.apk' '*.upx' '*.ozip' '*.dtb' '*.dtbo'
  '*.p7s' '*.pem' '*.key' '*.keystore' '*.jks'
  '*memorydump*' '*ramdump*' '*DDRCS*' 'gate2a/*' '*gpt_*before*'
)
DENY_RES=(
  '-----BEGIN ([A-Z]+ )?PRIVATE KEY-----'
  '(^|[^0-9A-Fa-f:])([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}([^0-9A-Fa-f:]|$)'
  '/home/[a-z_][a-z0-9_-]*/'
  'ghp_[A-Za-z0-9]{36}'
  'github_pat_[A-Za-z0-9_]{40,}'
)
# MAC-shaped strings that are not personal: all-zero, broadcast, documentation ranges
MAC_OK='(00:){5}00|([Ff][Ff]:){5}[Ff][Ff]|(([0-9A-Fa-f]{2}:){2})?(00:00:5[Ee]:)'
ALLOW_PATHS=()

root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "safety-scan: not in a git repository" >&2; exit 2; }
if [ -f "$root/.safety-scan" ]; then
  while read -r kind arg; do
    case "$kind" in
      ''|'#'*) ;;
      allow-path) ALLOW_PATHS+=("$arg") ;;
      deny-path) DENY_PATHS+=("$arg") ;;
      deny-re) DENY_RES+=("$arg") ;;
      max-size) MAX_SIZE=$arg ;;
      *) echo "safety-scan: unknown rule '$kind' in .safety-scan" >&2; exit 2 ;;
    esac
  done < "$root/.safety-scan"
fi

flagged=0
flag() { echo "FLAG  $1  ($2)"; flagged=1; }

matches() {  # matches PATH GLOB...
  local p=$1 g; shift
  for g in "$@"; do
    # shellcheck disable=SC2053
    [[ $p == $g || ${p##*/} == $g ]] && return 0
  done
  return 1
}

check_blob() {  # check_blob OID PATH
  local oid=$1 path=$2 size re hit
  [ "${#ALLOW_PATHS[@]}" -gt 0 ] && matches "$path" "${ALLOW_PATHS[@]}" && return
  matches "$path" "${DENY_PATHS[@]}" && flag "$path" "denied file type/path"
  size=$(git cat-file -s "$oid" 2>/dev/null) || return
  [ "$size" -gt "$MAX_SIZE" ] && flag "$path" "size $size > $MAX_SIZE"
  [ "$size" -gt "$MAX_SIZE" ] && return
  for re in "${DENY_RES[@]}"; do
    hit=$(git cat-file -p "$oid" | grep -a -n -m1 -E -e "$re" 2>/dev/null) || continue
    if [[ $re == *'{5}'* ]] && ! grep -q -E -v -e "$MAC_OK" <<<"$hit"; then continue; fi
    flag "$path" "content matches /$re/ at line ${hit%%:*}"
  done
}

scan_staged() {
  local mode oid stage path
  while IFS=$'\t' read -r meta path; do
    read -r mode oid stage <<<"$meta"
    [ "$mode" = 160000 ] && continue   # submodule
    check_blob "$oid" "$path"
  done < <(git diff --cached --name-only --diff-filter=ACMR -z | xargs -0 -r git ls-files -s --)
}

scan_range() {  # every blob introduced by the commits in the range
  local seen=" " c line oid path
  for c in $(git rev-list "$@"); do
    while read -r line; do
      oid=$(awk '{print $4}' <<<"${line%%$'\t'*}")
      path=${line#*$'\t'}
      [[ $seen == *" $oid "* ]] && continue
      seen+="$oid "
      [ "$oid" = 0000000000000000000000000000000000000000 ] && continue
      git cat-file -e "$oid" 2>/dev/null || continue
      [ "$(git cat-file -t "$oid")" = blob ] || continue
      check_blob "$oid" "$path"
    done < <(git diff-tree -r --root --no-commit-id --diff-filter=ACMR --no-renames "$c")
  done
}

case "${1:-}" in
  --staged) scan_staged ;;
  --range) shift; scan_range "$@" ;;
  --all) scan_range --all ;;
  --pre-push)
    z=0000000000000000000000000000000000000000
    while read -r lref lsha rref rsha; do
      [ "$lsha" = "$z" ] && continue          # branch deletion
      if [ "$rsha" = "$z" ]; then scan_range "$lsha" --not --remotes
      else scan_range "$rsha..$lsha"; fi
    done ;;
  *) sed -n '4,20p' "$0" | sed 's/^# \{0,1\}//'; exit 2 ;;
esac

if [ "$flagged" -ne 0 ]; then
  echo "safety-scan: flagged content above. Remove it (and from history if already committed)," >&2
  echo "or add a reviewed 'allow-path' rule to .safety-scan." >&2
  exit 1
fi
echo "safety-scan: clean"
