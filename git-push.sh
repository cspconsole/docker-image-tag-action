#!/bin/bash

if [[ "$IS_NEW_TAG" == 'true' ]];
then
  git config --local user.email "action@github.com"
  git config --local user.name "GitHub Action"

  git tag -a -s $TAG -m "Release $TAG"

  echo "Pushing to branch $BRANCH"
  echo "Tag : $TAG"
  echo "Token $GITHUB_TOKEN"

  if [[ -z "$GITHUB_TOKEN" ]]
  then
      echo 'Missing input "github-token"'
      exit 1
  fi

  git push origin v$TAG
else
  echo "Doing nothing. Tag $TAG exists"
fi