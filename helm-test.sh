#!/bin/bash

set -u
set -e
set -o pipefail

rm -rf data temp

for chart in */Chart.yaml; do
  chart=$(dirname $chart)
  echo "Doing - $chart"

  helm dep update $chart
  helm lint $chart
  [ ! -z "$(echo $chart | egrep 'dotnet|golang|java|nodejs|web')" ] && {
    [ -d data ] && rm -rf data
    mkdir data temp
    helm template $chart --output-dir temp --set istio.enabled=1 --set csi.enabled=1
    for f in temp/$chart/templates/*.yaml; do dst="data/$(basename $f | sed 's/yaml/json/g')"; yq eval $f -o json > $dst; done
    conftest test data/*
    rm -rf data temp
  }
done

