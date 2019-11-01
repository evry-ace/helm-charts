#!/bin/bash

set -u
set -e
set -o pipefail

for chart in */Chart.yaml; do
  chart=$(dirname $chart)

  helm lint $chart
done
