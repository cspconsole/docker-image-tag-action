#!/bin/bash

if [[ "$IS_NEW_TAG" == 'true' ]];
then
  git config --local user.email "action@github.com"
  git config --local user.name "GitHub Action"

  git tag -a -s $TAG -m "Release $TAG"

  echo "Branch $BRANCH"
  echo "Tag: $TAG"

  git push origin v$TAG
else
  echo "Doing nothing. Tag $TAG exists"
fi