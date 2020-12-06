#!/bin/bash
set -e

if [[ "$IS_NEW_TAG" == 'true' ]];
then
  git config --local user.email "action@github.com"
  git config --local user.name "GitHub Action"

  git tag -a $TAG -m "Release $TAG"

  echo "Pushing to branch $BRANCH";
  [ -z "${GITHUB_TOKEN}" ] && {
      echo 'Missing input "github-token"';
      exit 1;
  };

  REMOTE_REPO="https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

  git push "$REMOTE_REPO" HEAD:$BRANCH --follow-tags --tags;
else
  echo "Doing nothing. Tag $TAG exists"
fi