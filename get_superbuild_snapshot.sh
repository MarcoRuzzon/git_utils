usage="$(basename "$0") [-h] [-s SUPERBUILD_DIR][-t TARGET_DIR]
Create a project CMakeLists.txt and a ProjectsTags.cmake representing the current state of the superbuild:
    -h  show this help text
    -s  superbuild directory
    -d  target directory where to save files (default current directory) (not working)"

while getopts ":hs:t:" option
do
	case "${option}" in
	  h) echo "$usage"; exit;;
		s) SUPERBUILD_DIR=${OPTARG};;
    t) TARGET_DIR=${OPTARG};;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
    \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
	esac
done

if [ ! "$SUPERBUILD_DIR" ]; then
   echo "$usage" >&2; exit 1
fi

if [ ! "$TARGET_DIR" ]; then
  TARGET_DIR=("$(pwd)")
fi

SUPERBUILD_CONFIG="$(mktemp)"
REPOS_INFO="$(mktemp)"

./save_repos_info.sh -f $REPOS_INFO -d "$SUPERBUILD_DIR/external"

./save_superbuild_config.py "$SUPERBUILD_DIR/build/CMakeCache.txt" --yaml_filename "$SUPERBUILD_CONFIG"

./create_project_CMakeLists.py $SUPERBUILD_CONFIG

cat $REPOS_INFO

./create_ProjectTags.py $REPOS_INFO
