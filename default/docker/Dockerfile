FROM alpine:3
RUN apk add --no-cache \
  bash \
  bats \
  curl \
  git \
  jq \
  make \
  py3-pip \
  py3-yaml

COPY --from=docker:20 /usr/local/bin/docker /usr/local/bin/
COPY --from=docker/compose:alpine-1.28.6 /usr/local/bin/docker-compose /usr/local/bin/
COPY --from=hadolint/hadolint:latest-alpine /bin/hadolint /usr/local/bin/
COPY --from=koalaman/shellcheck:stable /bin/shellcheck /usr/local/bin/

RUN pip3 install yq

#
# container runtime
#

ENTRYPOINT []
