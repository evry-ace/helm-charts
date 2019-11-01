#!/bin/bash

set -u
set -e
set -o pipefail

SRC_DIR=$1
DEST_DIR=$2

for chart in ${SRC_DIR}/*; do
  chart=$(basename $chart)

  mv -vn ${SRC_DIR}/${chart} ${DEST_DIR}/${chart}

  helm repo index .
done
