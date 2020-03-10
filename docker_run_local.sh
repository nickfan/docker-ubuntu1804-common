#!/usr/bin/env bash

docker rm -f docker-ubuntu1804-common
#docker run --name docker-ubuntu1804-common -d -v $(pwd)/home:/root/ --rm docker-ubuntu1804-common
docker run --name docker-ubuntu1804-common -d --rm docker-ubuntu1804-common
