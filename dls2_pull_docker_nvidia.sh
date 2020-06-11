#!/usr/bin/env bash

docker pull server-gitlab-runner:5000/dls2-env-nvidia:latest
docker pull server-gitlab-runner:5000/dls2-framework-dev-nvidia:latest
docker pull server-gitlab-runner:5000/dls2-plugin-dev-nvidia:latest
docker pull server-gitlab-runner:5000/dls2-operator-nvidia:latest
docker pull server-gitlab-runner:5000/dls2-plugin-trunk-nvidia-dev:latest

docker system prune -f
