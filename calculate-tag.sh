#!/bin/bash

# Fetch tags from repository
git fetch --prune --unshallow --tags

CURRENT_COMMIT=$(git rev-parse HEAD)
COMMIT_TAG=$(git tag --points-at "$CURRENT_COMMIT")
LAST_TAG=$(git tag --merge "${GITHUB_REF##*/}" | sort -rV | head -n 1)

TAG_REGEX='^v?[0-9]+\.[0-9]+\.[0-9]+$'
if ! [[ $LAST_TAG =~ $TAG_REGEX ]];
then
  echo "error: $LAST_TAG is not a valid tag " >&2; exit 1
fi

IS_NEW_TAG="false"

if [[ "$COMMIT_TAG" == "$LAST_TAG" ]];
then
  NEW_GIT_TAG="$COMMIT_TAG"
else
  # Iterate tag only if last commit doesn't have a tag
  NEW_GIT_TAG=$(echo $(echo "$LAST_TAG" | cut -d. -f1).$(echo "$LAST_TAG" | cut -d. -f2).$(echo $(($(echo "$LAST_TAG" | cut -d. -f3) + 1))))

  IS_NEW_TAG="true"
fi

LATEST_TAG=$(echo $(echo "$NEW_GIT_TAG" | cut -c2-))
LATEST_MINOR_TAG=$(echo $(echo "$LATEST_TAG" | cut -d. -f 1-2)"-latest")
LATEST_MAJOR_TAG=$(echo $(echo "$LATEST_TAG" | cut -d. -f 1)"-latest")

echo "latest-tag=$(echo $LATEST_TAG) >> $GITHUB_OUTPUT"
echo "latest-minor-tag=$(echo $LATEST_MINOR_TAG) >> $GITHUB_OUTPUT"
echo "latest-major-tag=$(echo $LATEST_MAJOR_TAG) >> $GITHUB_OUTPUT"
echo "is-new-tag=$(echo $IS_NEW_TAG) >> $GITHUB_OUTPUT"
echo "current-commit=$(echo ${CURRENT_COMMIT::6}) >> $GITHUB_OUTPUT"
