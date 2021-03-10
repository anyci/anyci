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

  cd "$PROJECT_ROOT" || die "failed to enter PROJECT_ROOT"
  "$ANYCI_ROOT/bin/exec" "$@"
}

lib/lookup(){
  dlog "lookup: $1"
  for p in "${__SEARCH_PATHS[@]}"; do
    [ -e "$p/$1" ] && {
      dlog "    found ${p/$ANYCI_ROOT/<anyci workspace>}/$1"
      echo "$p/$1"
      return 0
    }
    dlog "    tried ${p/$ANYCI_ROOT/<anyci workspace>}/$1"
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
    __SEARCH_PATHS+=("$p")
  done
  [ -n "$ANYCI_FAMILY" ] && __SEARCH_PATHS+=("$ANYCI_ROOT/family/$ANYCI_FAMILY")
  __SEARCH_PATHS+=("$ANYCI_ROOT/group/$ANYCI_GROUP")
}

export ANYCI_ROOT
__lib_exec_initialized=false
