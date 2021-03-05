#!/usr/bin/env bash
# shellcheck ignore-variable-pattern=__
lib/read/paths()(
  IFS=:; set -o noglob
  for p in $1; do
    echo "$p"
  done
)

lib/require/dir(){
  for d in "$@"; do
    [ -d "$d" ] || die "missing directory: $d"
  done
}

lib/lookup(){
  log "looking for '$1' $2"
  for p in "${__SEARCH_PATHS[@]}"; do
    [ -e "$p/$1" ] && {
      echo "$p/$1"
      return 0
    }
    log "    tried ${p/$ANYCI_ROOT/<anyci workspace>}/$1"
  done
  return 1
}
