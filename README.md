## SOME SUPERBUILD UTILS

`$ ./get_superbuild_snapshot.sh  [-h] [-s SUPERBUILD_DIR][-t TARGET_DIR]`

Create a project CMakeLists.txt and a ProjectsTags.cmake representing the
current state of the superbuild in SUPERBUILD_DIR and save them in 
TARGET_DIR (default ./tmp)

To restore the superbuild to this state it is sufficient to:
 - substitute the ProjectsTags.cmake in the cmake directory of the superbuild with the generated one
 - substitute a project CMakeLists.txt with the generated one and activate only this project  
 - compile the superbuild
 
`$ ./save_repos_info.sh [-h] [-f FILENAME] [-d DIRECTORIES]`

Save a yaml file to FILENAME with a summary of all git repositories 
in DIRECTORIES (default current directory)