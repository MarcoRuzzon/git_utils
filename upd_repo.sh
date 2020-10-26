#!/bin/bash

set -e   # exit on any error

while getopts "t:R:r" option
do
	case "${option}" in
	  t) TAG=${OPTARG};;   # make it mandatory
		R) ROOT=${OPTARG};;
		r) REPOSITORY=${OPTARG};;
	esac
done

TAG=${TAG:-master}
ROOT=${ROOT:-~}
REPOSITORY=${REPOSITORY:-"test_repo"}

REPOSITORIES=("$ROOT/$REPOSITORY")

for REPO in "${REPOSITORIES[@]}"
do
  if ! [ -d "$REPO" ]
  then
    echo "Skipping $REPO: directory not found"
    continue
  else
    echo "Updating $REPO at $(date)"
    if [ -d "$REPO/.git" ]
    then
      cd "$REPO"
      git status
      echo "Pulling"
      git pull
      echo "Checking out Tag $TAG"
      git checkout "$TAG"
    else
      echo "Skipping because it doesn't look like it has a .git folder."
    fi
    echo "Done at $(date)"
    echo
  fi
done