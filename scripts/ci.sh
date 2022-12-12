#!/usr/bin/env bash
set -euxo

# Go to the root of the repo
cd "$(git rev-parse --show-toplevel)"

# Get a list of the current files in package form by querying Bazel.
head=$(git merge-base origin/main HEAD)
if [[ ! -z $GITHUB_BASE_REF ]]; then
  changedFiles=$(git diff --name-only $GITHUB_SHA..$head)
else
  changedFiles=$(git diff --name-only $head~1)
fi

files=()
for file in $changedFiles; do
  echo $file
  if [[ $file = src/* ]]
  then
    files+=($(bazelisk query $file))
    echo $(bazelisk query $file)
  fi
done


# Query for the associated buildImages
buildImages=$(bazelisk query \
    --keep_going \
    "filter(.*_image$, rdeps(//..., set(${files[*]})))")    

# Build the docker images only for the changed services
if [[ ! -z $buildImages ]]; then
  echo "Building docker images"
  bazelisk build $buildImages
fi

# Query for the associated Images to push
pushImages=$(bazelisk query \
    --keep_going \
    "kind(container_push, rdeps(//..., set(${files[*]})))")

# Push the docker images only for the changed services
if [[ ! -z $pushImages ]]; then
  echo "Pushing docker images"
  bazelisk run $pushImages
fi
