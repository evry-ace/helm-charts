#!/bin/bash

set -u
set -e
set -o pipefail

for chart in */Chart.yaml; do
  chart=$(dirname $chart)

  helm lint $chart
  [ ! -z "$(echo $chart | egrep '(dotnet|golang|java|nodejs|web)')" ] && {
    [ -d data ] && rm -rf data
    mkdir data
    helm template $chart --output-dir temp --set istio.enabled=1 --set csi.enabled=1
    for f in temp/$chart/templates/*.yaml; do dst="data/$(basename $f | sed 's/yaml/json/g')"; yq read $f -j > $dst; done
    conftest test data/*
    rm -rf data
  }
done
