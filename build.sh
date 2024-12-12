PYTHON_VERSION=3.13
IMAGE_NAME=arm32v7/python:${PYTHON_VERSION}-alpine

docker run --rm -v "$(pwd):/work" -w /work ${IMAGE_NAME} /bin/sh -c "tar -cvf python-${PYTHON_VERSION}-armv7-musl.tar.gz -T copyfiles"
