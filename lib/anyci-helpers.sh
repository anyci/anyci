#!/usr/bin/env bash

lib/exec(){
  $__lib_exec_initialized || {
    export EXEC_IMAGE="${EXEC_IMAGE:-$ANYCI_IMAGE}"
    export EXEC_DOCKER_FLAGS="-v,$ANYCI_ROOT:$ANYCI_ROOT:ro"

    [ -n "$EXEC_IMAGE" ] || {
      dlog "ANYCI_IMAGE not provided. Will build from Dockerfile..."
      EXEC_DOCKERFILE="$(lib/lookup docker/Dockerfile)"
      export EXEC_DOCKERFILE
    }
    __lib_exec_initialized=true
  }

  "$ANYCI_ROOT/bin/exec" "$@"
}

lib/help(){
  lib/version
  log "AnyCI Step Usage: anyci [step...]"
  log "              ex: bin/ci larry curly moe"
  log "AnyCI Exec Usage: anyci exec <cmd...>"
  log "              ex: bin/ci exec gradle --version"
  log "              ex: bin/ci exec sh"
  log "See https://github.com/anyci/anyci for more"
}

lib/lookup(){
  dlog "lookup: $1"
  for p in "${__SEARCH_PATHS[@]}"; do
    [ -e "$p/$1" ] && {
      dlog "    \033[1mfound ${p//$ANYCI_ROOT/<anyci>}/$1\033[0m"
      echo "$p/$1"
      return 0
    }
    dlog "    tried ${p//$ANYCI_ROOT/<anyci>}/$1"
  done
  dlog "    lookup failed"
  return 1
}

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

lib/set/search_paths(){
  __SEARCH_PATHS=()
  for p in $(lib/read/paths "$1"); do
    __SEARCH_PATHS+=("${p//^/$ANYCI_ROOT/}")
  done
}

lib/version(){
  log "AnyCI version: $(git -C "$ANYCI_ROOT" rev-parse --short HEAD) ($(git -C "$ANYCI_ROOT" rev-parse --abbrev-ref HEAD))"
}

export ANYCI_ROOT
__lib_exec_initialized=false
