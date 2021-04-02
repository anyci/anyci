FROM alpine:3 as base
RUN apk add --no-cache \
  bash \
  curl \
  docker-compose \
  git \
  jq \
  make \
  yq

COPY --from=docker:20 /usr/local/bin/docker /usr/local/bin/docker
COPY --from=hadolint/hadolint:latest-alpine /bin/hadolint /usr/local/bin/hadolint
COPY --from=koalaman/shellcheck:stable /bin/shellcheck /usr/local/bin/shellcheck

#
# container runtime
#

ENTRYPOINT []
