#!/usr/bin/env python

import argparse
import yaml

parser = argparse.ArgumentParser()
parser.add_argument('filename', help="the yaml file containing git repos info")
parser.add_argument('--cmake_min_version', metavar="VERSION", default="2.8.12", type=str)
parser.add_argument('--gitlab_advrcloud_base_address', metavar="ADDRESS", help="Address to use for ADVR cloud Gitlab git repositories",
                    default="ssh://git@gitlab.advrcloud.iit.it/", type=str)
parser.add_argument('--gitlab_advr_base_address', metavar="ADDRESS", help="Address to use for ADVR Gitlab git repositories",
                    default="ssh://git@gitlab.advr.iit.it/", type=str)
args = parser.parse_args()

with open(args.filename) as file:
    try:
        info = yaml.safe_load(file)

    except Exception as e:
        raise Exception('error in yaml parsing')

template = "find_or_build_package_with_tag({} ON)\n"
with open('CMakeLists.txt', "w") as f:

    f.write("cmake_minimum_required(VERSION {})\n\n".format(args.cmake_min_version))
    f.write('set(YCM_GIT_GITLAB_ADVRCLOUD_BASE_ADDRESS "{}" CACHE STRING "Address to use for ADVR cloud Gitlab git repositories" FORCE)\n'.format(args.gitlab_advrcloud_base_address))
    f.write('set(YCM_GIT_GITLAB_ADVR_BASE_ADDRESS "{}" CACHE STRING "Address to use for ADVR Gitlab git repositories" FORCE)\n\n'.format(args.gitlab_advr_base_address))

    for item in info['repos']:
        f.write(template.format(item['name']))
