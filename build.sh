PYTHON_VERSION=3.13
ALPINE_VERSION=3.21
IMAGE_NAME=arm32v7/python:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

docker run --rm --platform linux/arm/v7 -v "$(pwd):/work" -w /work ${IMAGE_NAME} /bin/sh -c "tar -cvf python-${PYTHON_VERSION}-alpine${ALPINE_VERSION}-armv7-musl.tar.gz -T copyfiles"
