#!/usr/bin/env bash
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
