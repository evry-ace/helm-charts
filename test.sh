#!/bin/bash
set -u
set -e
set -o pipefail

helm lint *

for dir in test/*/; do
  chart=$(basename ${dir})

  for file in ${dir}*; do
    echo "${chart} - $(basename ${file})"
    helm template ${chart} -f ${file} --name=test-dev | kubeval --strict
  done
done
