#!/usr/bin/env bash

#
# the CI platform should provide these variables. these are fallback defaults
# that are used when building locally or if the CI platform does not provide.

# the pipeline ID is used version tagging images &c. typically <branch>-<rev>
export PIPELINE_ID="${PIPELINE_ID:-local-0}"

# modeled from OCI image spec:
#  https://github.com/opencontainers/image-spec/blob/master/annotations.md
export __AUTHORS="${__AUTHORS:-$(git log --format="%aN <%aE>" -n 1 HEAD)}"
export __CREATED="${__CREATED:-$(date -u +"%Y-%m-%dT%H:%M:%SZ")}"
export __REVISION="${__REVISION:-$(git rev-parse HEAD)}"
export __SOURCE="${__SOURCE:-$(git remote get-url origin)}"
export __URL="${__URL:-unknown}"
export __VERSION="${__VERSION:-0.0.0}"
