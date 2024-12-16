PYTHON_VERSION=3.13
ALPINE_VERSION=3.21
IMAGE_NAME=arm32v7/python:${PYTHON_VERSION}-alpine${ALPINE_VERSION}
TARGZ_NAME=python-${PYTHON_VERSION}-alpine${ALPINE_VERSION}-armv7-musl.tar.gz

docker run \
  --rm \
  --platform linux/arm/v7 \
  -v "$(pwd):/work" \
  -w /work \
  ${IMAGE_NAME} \
  /bin/sh -c "ln -s /usr/local/bin/python3 /usr/bin/python3 && tar -cvf ${TARGZ_NAME} -T copyfiles"
