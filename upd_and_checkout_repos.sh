#!/bin/bash

set -e   # exit on any error

usage="$(basename "$0") [-h] [-t TAG] [-r REPOSITORIES]
Update and checkout REPOSITORIES to TAG:
    -h  show this help text
    -t  tag name
    -r  repository absolute path (can be repeated for multiple repos)"

while getopts ":ht:r::" option
do
	case "${option}" in
	  h) echo "$usage"; exit;;
	  t) TAG=${OPTARG};;   # make it mandatory
		r) REPOSITORIES+=("$OPTARG");;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
    \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
	esac
done

for REPO in "${REPOSITORIES[@]}"
do
  if ! [ -d "$REPO" ]
  then
    echo "$REPO not found: aborting before checking out any repo"
    exit 1
  fi
done

for REPO in "${REPOSITORIES[@]}"
do
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
done
