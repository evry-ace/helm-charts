#!/bin/bash
set -e
set -o pipefail

chart=$1
version=$2
chartDir=release

function print_usage {
  echo "$0 <chart> <version>"
  echo "  Release new version of chart"
}

function check_branch {
  if [ $(git rev-parse --abbrev-ref HEAD) != "master" ]; then
    echo "$0 can only be run on master branch!"
    exit 1
  fi
}

function check_remote {
  UPSTREAM="@{u}"
  LOCAL=$(git rev-parse @)
  REMOTE=$(git rev-parse "$UPSTREAM")
  BASE=$(git merge-base @ "$UPSTREAM")

  if [ $LOCAL = $REMOTE ]; then
    true
    # echo "Local branch is up to date with remote!"
  elif [ $LOCAL = $BASE ]; then
    echo "Error: Local branch is not up to date with remote!"
    exit 1
  fi
}

function check_changes {
  if ! git diff-index --quiet HEAD --; then
    echo "Error: Your index contains uncommitted changes!"
    exit 1
  fi
}

if [ -z "${chart}" ]; then
  print_usage
  echo ""
  echo "Error: No chart name specified!"
  exit 1
fi

if [ -z "${version}" ]; then
  print_usage
  echo ""
  echo "Error: No chart version specified!"
  exit 1
fi

if [ ! -d "${chart}" ]; then
  echo "Error: Chart does not exist!"
  exit 1
fi

check_branch
check_remote
check_changes

echo "Release: compute changes since previous version"
tag=$(git tag | grep "${chart}-" || echo "" | tail -n 1) || ""

echo $tag

if [ "$tag" != "" ]; then
  git log --pretty=format:'%h - %s <%an>' --abbrev-commit ${tag}...HEAD | grep "${chart}:" || true
else
  echo "First release of ${chart} 🎉"
fi

echo "Release: update chart version"
sed -i -e "s/version\:.*/version\: ${version}/g" ${chart}/Chart.yaml

echo "Release: packaging helm chart"
package=$(basename $(helm package $chart | awk '{ print $NF }'))

if [ -f "${chartDir}/${package}" ]; then
  # Revert version increment in Chart.yaml
  git checkout -- ${chart}/Chart.yaml

  # Remvoe duplicate Chart version pakcage
  rm ${package}

  echo "Error: A release of ${chart} with version ${version} already exists!"
  exit 1
fi

echo "Release: moving packaged chart to ${chartDir} directory"
mv -vn ${package} ${chartDir}

echo "Release: re-indexing chart repository"
helm repo index .

echo "Release: commiting to git"
git reset HEAD .
git add index.yaml
git add ${chartDir}
git add ${chart}/Chart.yaml
git commit -m "${chart}: release v${version}"
git tag -a "${chart}-${version}" -m "${chart} v${version}"

echo "Release: run \"git push --tags origin master\""
