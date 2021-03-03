#!/bin/bash

set -u
set -e
set -o pipefail

PUBLISH_DIR=$1

for chart in */Chart.yaml; do
  chart=$(dirname $chart)

  helm package $chart -d ${PUBLISH_DIR} 
done

