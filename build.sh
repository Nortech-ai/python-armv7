pushd() {
    command pushd "$@" > /dev/null
}

popd() {
    command popd "$@" > /dev/null
}

# The --owner and --group options are not supported by the macOS tar
# So we use gtar if we are on macOS
#
# To install run "brew install gnu-tar"
if [[ $(uname) == "Darwin" ]]; then
    TAR=$(which gtar)
else
    TAR=$(which tar)
fi

PYTHON_VERSION=3.13
ALPINE_VERSION=3.21
ALPINE_ARCH=armv7

mkdir -p tmp

# For each package in packages/
for package in packages/*; do
  # Read package name from alpine-name
  ALPINE_PACKAGE_NAME=$(cat ${package}/alpine-name)
  PACKAGE_NAME=${ALPINE_PACKAGE_NAME%.*}

  echo "Building ${package}"
  
  # Clean up the tmp directory
  rm -rf tmp/${package}

  # Create a directory for the package in tmp/
  mkdir -p tmp/${package}
  mkdir -p tmp/${package}/data

  # Copy the control folder
  cp -r ${package}/control tmp/${package}/control

  # Download the package
  curl --silent -o tmp/${ALPINE_PACKAGE_NAME} https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/main/${ALPINE_ARCH}/${ALPINE_PACKAGE_NAME}

  # Extract the package
  $TAR --warning=no-unknown-keyword -xf tmp/${ALPINE_PACKAGE_NAME} -C tmp/${package}/data

  # Remove the package
  rm tmp/${ALPINE_PACKAGE_NAME}

  # Alpine packages bring a .PKGINFO and a .SIGN file that we need to remove
  rm -rf tmp/${package}/data/.PKGINFO
  rm -rf tmp/${package}/data/.SIGN*

  # Create the debian-binary file
  echo 2.0 > tmp/${package}/debian-binary

  pushd tmp/${package}/control
  $TAR --numeric-owner --group=0 --owner=0 -czf ../control.tar.gz ./*
  popd

  pushd tmp/${package}/data

  # In our system /lib is a symlink to /usr/lib and opkg complains if we
  # try to install a package that has a file in /lib.
  # So move all files in /lib to /usr/lib
  if [ -d lib ]; then
    mkdir -p usr/lib
    mv lib/* usr/lib/
    rm -rf lib
  fi
  
  $TAR --numeric-owner --group=0 --owner=0 -czf ../data.tar.gz ./*
  popd

  pushd tmp/${package}
  $TAR --numeric-owner --group=0 --owner=0 -cf ../${PACKAGE_NAME}-alpine${ALPINE_VERSION}-${ALPINE_ARCH}.ipk ./debian-binary ./data.tar.gz ./control.tar.gz 
  popd
done
