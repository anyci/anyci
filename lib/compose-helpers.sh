#!/usr/bin/env bash

compose_flags=(
  -p "${PROJECT_NAME:-anyci}-$PIPELINE_ID"
)

compose(){
  docker-compose "${compose_flags[@]}" "$@"
}

compose/export_vars(){
  local services service container id container_port host_ip host_port

  #
  # loop through all services in the composition and export environment variables
  # containing port information useful in downstream tests. example output;
  #    STACK_CONTAINER_FOO=/acme-local-0_foo_1
  #    STACK_CONTAINER_PING_PONG=/acme-local-0_ping-pong_1
  #    STACK_CONTAINER_POSTGRESQL=/acme-local-0_postgresql_1
  #    STACK_ENDPOINT_PING_PONG_443=host.docker.internal:57037
  #    STACK_ENDPOINT_PING_PONG_80=host.docker.internal:57038
  #    STACK_ENDPOINT_POSTGRESQL_5432=host.docker.internal:57036
  #    STACK_SERVICES=FOO,PING_PONG,POSTGRESQL
  #
  services=()
  for service in $(compose ps --services | sort); do
    [ "$service" = "deps" ] && continue

    id="${service//[^A-Za-z0-9_]/_}"
    id="${id^^}"
    services+=("$id")

    container="$(compose ps -q "$service")"
    eval "export STACK_CONTAINER_${id}=$(docker inspect -f '{{ .Name }}' "$container")"
    while read -r container_port host_ip host_port; do
      [ -n "$container_port" ] || continue
      [ "${__DOCKER_DESKTOP:-false}" = false ] || host_ip="host.docker.internal"
      eval "export STACK_ENDPOINT_${id}_${container_port//[^0-9]/}=$host_ip:$host_port"
    done < <(docker inspect -f '{{range $p, $conf := .NetworkSettings.Ports}}{{println $p (index $conf 0).HostIp (index $conf 0).HostPort }}{{end}}' "$container")
  done
  export STACK_SERVICES="$(IFS=,;echo "${services[*]}")"
}
