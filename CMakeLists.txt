cmake_minimum_required(VERSION 2.8.12)

set(YCM_GIT_GITLAB_ADVRCLOUD_BASE_ADDRESS "ssh://git@gitlab.advrcloud.iit.it/" CACHE STRING "Address to use for ADVR cloud Gitlab git repositories" FORCE)
set(YCM_GIT_GITLAB_ADVR_BASE_ADDRESS "ssh://git@gitlab.advr.iit.it/" CACHE STRING "Address to use for ADVR Gitlab git repositories" FORCE)

find_or_build_package_with_tag(CartesianInterface ON)
find_or_build_package_with_tag(GazeboXBotPlugin ON)
