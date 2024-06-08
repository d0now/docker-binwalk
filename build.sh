#!/bin/bash

set -x

if [ $(whoami) != "root" ]; then
    echo "please run as root."
    exit 1
fi

PROJ_ROOT=$(dirname -- $0)
PROJ_ROOT=$(realpath $PROJ_ROOT)

if [ -z $1 ]; then
    VERSION=2.3.4
else
    VERSION=$1
fi

cd $PROJ_ROOT && docker build --build-arg VERSION=$VERSION -t binwalk:$VERSION .
