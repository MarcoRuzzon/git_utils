#!/bin/bash

set -e   # exit on any error

usage="$(basename "$0") [-h] [-t TAG] [-r REPOSITORIES]
Tag the current commit of multiple repositories:
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

# mandatory arguments
if [ ! "$TAG" ] || [ ! "$REPOSITORIES" ]; then
  echo "arguments -t and -r must be provided"
  echo "$usage" >&2; exit 1
fi

function check_tag {
  if GIT_DIR=$1 git tag --list | grep -E -q "^$2$"
  then
      return 1
  else
      return 0
  fi
}

for REPO in "${REPOSITORIES[@]}"
do
  echo "$(check_tag "$REPO/.git" "$TAG")"
  #if check_tag $REPO/.git $TAG
  if [[ "$(check_tag $REPO/.git $TAG)" != "0" ]]
  then
    echo "ERROR: Repository $REPO already has Tag $TAG -> No repository was tagged"
    exit 1
  fi
done

for REPO in "${REPOSITORIES[@]}"
do
  if ! [ -d "$REPO" ]
  then
    echo "Skipping $REPO: directory not found"
    continue
  else
    if [ -d "$REPO/.git" ]
    then
      echo
      echo "Repository: $REPO:"
      cd "$REPO"
      echo "Current Commit:"
      git log -1
      echo "Tagging current commit with Tag $TAG"
      git tag "$TAG"
      echo "Pushing tags to origin"
      git push --tags origin
    else
      echo "Skipping because it doesn't look like it has a .git folder."
    fi
    echo "Done"
    echo
  fi
done