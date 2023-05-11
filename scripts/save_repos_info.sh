#!/usr/bin/env bash

DEFAULT_FILENAME=repos_info.yaml

usage="usage: $(basename "$0") [-h] [-n FILENAME] [-d DIRECTORY]

Save a yaml file to FILENAME (default $DEFAULT_FILENAME) with a 
summary of all git repositories in DIRECTORY (default current directory):
    -h  show this help text
    -n  filename with repos info (can be a relative/absolute path)
    -d  repositories parent dir (can be repeated for multiple directories)

example:

repos:
  - root: /home/tree
    name: fake_repo
    branch: (HEAD detached at v0.5)
    commit: 7df3f22
    origin: git@github.com:user/fake_repo.git
    modified_or_untracked: 0


  - root: /home/tree
    name: test_repo
    branch: master
    commit: d9768ee
    origin: git@github.com:user/test_repo.git
    modified_or_untracked: 3"


while getopts ":hd::n:" option
do
	case "${option}" in
	  h) echo "$usage"; exit;;
    n) FILENAME=${OPTARG};;
		d) DIRS+=("$OPTARG");;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
    \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
	esac
done

if [ ! "$FILENAME" ]; then
  echo "no FILENAME specified, using $DEFAULT_FILENAME"
  FILENAME=$DEFAULT_FILENAME
fi

if [ ! "$DIRS" ]; then
  echo "no DIRECTORY specified, using current dir"
  DIRS=("$(pwd)")
fi

function parse_git_dirname() {
  dirname "$(git --git-dir $1/.git rev-parse --show-toplevel 2> /dev/null | sed "s/\(.*\)/\1/")"
}

function parse_git_basename() {
  basename "$(git --git-dir $1/.git rev-parse --show-toplevel 2> /dev/null | sed "s/\(.*\)/\1/")"
}

# checks if branch has something pending
function parse_git_dirty() {
  git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && echo "*"
}

# gets the current git branch
function parse_git_branch() {
  git --git-dir $1/.git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/"
}

# get last commit hash prepended with @ (i.e. @8a323d0)
function parse_git_hash() {
  git --git-dir $1/.git rev-parse --short HEAD 2> /dev/null | sed "s/\(.*\)/\1/"
}

# get remote  
function get_remote_url() {
  git --git-dir $1/.git config --get remote.$2.url
}

function get_modified_or_untracked() {
  git --git-dir $1/.git --work-tree=$1 status --porcelain=v1 2>/dev/null | wc -l
}

if [[ -f "$(readlink -f "$FILENAME")" ]]; then
#  echo "WARNING: $FILENAME already exist, saving a backup before overwriting it"
#  cp "$(readlink -f "$FILENAME")" "$(readlink -f "$FILENAME")".backup
  rm "$(readlink -f "$FILENAME")"
fi

echo "repos:" >> "$(readlink -f "$FILENAME")"

for dir in "${DIRS[@]}"; do
  for f in "$dir"/*; do
    if [[ -d "$f/.git" ]]; then
      echo "  - root: $(readlink -f "$dir")
    name: $(basename "$f")
    branch: $(parse_git_branch "$f")
    commit: $(parse_git_hash "$f") 
    origin: $(get_remote_url "$f" "origin")
    modified_or_untracked: $(get_modified_or_untracked "$f")" >> "$(readlink -f "$FILENAME")"
  echo >> "$(readlink -f "$FILENAME")"
    fi
  done
done



