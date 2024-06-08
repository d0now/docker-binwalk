#!/bin/bash

set -x

PROJ_ROOT=$(dirname -- $0)
PROJ_ROOT=$(realpath $PROJ_ROOT)

if [ -z $1 ]; then
    VERSION=2.3.4
else
    VERSION=$1
fi

cd $PROJ_ROOT && docker build --platform linux/amd64 --build-arg VERSION=$VERSION -t binwalk:$VERSION .
