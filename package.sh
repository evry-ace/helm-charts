#!/bin/bash

set -u
set -e
set -o pipefail

dest=$1

for chart in */Chart.yaml; do
  chart=$(dirname $chart)

  helm package $chart -d tmp --save=false
done

