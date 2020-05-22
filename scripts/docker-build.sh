#!/usr/bin/env bash

cd "$(dirname "$0")/.." || exit

export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

docker-compose build --parallel || COMPOSE_DOCKER_CLI_BUILD=0 docker-compose build --parallel