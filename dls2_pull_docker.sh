#!/usr/bin/env bash

docker pull server-gitlab-runner:5000/dls2-framework-dev:latest
docker pull server-gitlab-runner:5000/dls2-plugin-dev:latest
docker pull server-gitlab-runner:5000/dls2-operator:latest
docker system prune -f
