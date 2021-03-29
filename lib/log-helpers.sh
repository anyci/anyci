#!/usr/bin/env bash

log(){ printf "# %-${__lpad:-17}s [${__ll:-INFO}] $*\n" "(${ANYCI_STEP_NAME:-$__ENTRY})" >&2; }
dlog(){ __ll=debug log "$*"; }
die(){ __ll=ERR log "$*"; exit 1; }
