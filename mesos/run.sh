#!/bin/bash -e

trap popd EXIT
pushd "$(dirname "$0")"

rm -rf dist
mkdir -m 1777 dist

sudo docker build -t mesos-builder-1804 .

sudo docker run -it -v $(pwd)/dist:/opt/artifacts --rm=true mesos-builder-1804

mesos_deb=$(ls dist/)

cp dist/$mesos_deb .

echo "Package built: $mesos_deb"
