#!/usr/bin/env bash

docker rm -f docker-ubuntu1804-common
#docker run --name docker-ubuntu1804-common -v $(pwd)/home:/root/ -it docker-ubuntu1804-common /bin/zsh
docker run --name docker-ubuntu1804-common -it docker-ubuntu1804-common /bin/zsh
#docker exec -it docker-ubuntu1804-common /bin/zsh
