#!/usr/bin/env bash

docker pull server-harbor:80/dls/dls-env-nvidia:latest
docker pull server-harbor:80/dls/dls-dev-nvidia:latest
docker pull server-harbor:80/dls2/dls2-framework-dev-nvidia:latest
docker pull server-harbor:80/dls2/dls2-plugin-dev-nvidia:latest
docker pull server-harbor:80/dls2/dls2-operator-nvidia:latest
docker system prune -f
