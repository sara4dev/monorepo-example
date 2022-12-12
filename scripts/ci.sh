#!/usr/bin/env bash

# Go to the root of the repo
cd "$(git rev-parse --show-toplevel)"

# Get a list of the current files in package form by querying Bazel.
files=()
for file in $(git diff --name-only); do
  if [[ $file = src/* ]]
  then
    files+=($(bazelisk query $file))
    echo $(bazelisk query $file)
  fi
done


# Query for the associated buildables
buildables=$(bazelisk query \
    --keep_going \
    "filter(.*_image, rdeps(//..., set(${files[*]})))")

# Build the targets only for the chnaged files
if [[ ! -z $buildables ]]; then
  echo "Building docker images"
  bazelisk build $buildables
fi
