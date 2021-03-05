FROM alpine:3 as base
RUN apk add --no-cache bash curl

COPY --from=docker:20 /usr/local/bin/docker /usr/local/bin/docker
ARG DOCKER_COMPOSE_VERSION=1.28.5
ARG DOCKER_COMPOSE_SHA256SUM=46406eb5d8443cc0163a483fcff001d557532a7fad5981e268903ad40b75534c
# hadolint ignore=DL4006
RUN curl -fsSL https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose && \
  { [ "$(sha256sum /usr/local/bin/docker-compose | awk '{print $1}')" = "$DOCKER_COMPOSE_SHA256SUM" ] || exit 99 ; }

COPY --from=hadolint/hadolint:latest-alpine /bin/hadolint /usr/local/bin/hadolint
COPY --from=koalaman/shellcheck:stable /bin/shellcheck /usr/local/bin/shellcheck

#
# container runtime
#

ENTRYPOINT []
