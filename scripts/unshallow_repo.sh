#!/usr/bin/env bash
usage="usage: $(basename "$0") [-h] [-r REMOTE_NAME] [-v]

Unshallow the repo in the current dir, upadte refs of 
remote called REMOTE_NAME and fetch :
    -h  show this help text
    -r  remote name (default origin)
    -v verbose
"


while getopts ":hr:v" option
do
    case "${option}" in
	    h) echo "$usage"; exit;;
	    r) REMOTE_NAME=${OPTARG};;   # make it mandatory
        v) VERBOSE="-v";;
        \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
	esac
done

if [ ! "$REMOTE_NAME" ]; then
   REMOTE_NAME="origin"
   echo "using default remote: origin"
fi

git fetch $VERBOSE --unshallow
git config "remote.$REMOTE_NAME.fetch" "+refs/heads/*:refs/remotes/$REMOTE_NAME/*"
git fetch $VERBOSE $REMOTE_NAME