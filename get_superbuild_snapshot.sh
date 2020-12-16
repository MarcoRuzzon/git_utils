usage="
$(basename "$0") [-h] [-s SUPERBUILD_DIR][-t TARGET_DIR]

Create a project CMakeLists.txt and a ProjectsTags.cmake representing the
current state of the superbuild in SUPERBUILD_DIR and save them in
TARGET_DIR (default ./tmp):

    -h  show this help text
    -s  superbuild directory
    -d  target directory where to save files (default ./tmp)
"

while getopts ":hs:d:" option
do
	case "${option}" in
	  h) echo "$usage"; exit;;
		s) SUPERBUILD_DIR=${OPTARG};;
    d) TARGET_DIR=${OPTARG};;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
    \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
	esac
done

if [ ! "$SUPERBUILD_DIR" ]; then
   echo "$usage" >&2; exit 1
fi

if [ ! "$TARGET_DIR" ]; then
  TARGET_DIR=("$(pwd)/tmp")
fi

SUPERBUILD_CONFIG="$(mktemp)"
REPOS_INFO="$(mktemp)"

./save_repos_info.sh -f $REPOS_INFO -d "$SUPERBUILD_DIR/external"

./save_superbuild_config.py "$SUPERBUILD_DIR/build/CMakeCache.txt" --yaml_filename "$SUPERBUILD_CONFIG"

./create_project_CMakeLists.py $SUPERBUILD_CONFIG

cat $REPOS_INFO

./create_ProjectTags.py $REPOS_INFO

mkdir -p $TARGET_DIR
mv CMakeLists.txt $TARGET_DIR
mv ProjectsTags.cmake $TARGET_DIR

