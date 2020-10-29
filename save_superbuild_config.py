#!/usr/bin/env python

import argparse
import yaml
import re

parser = argparse.ArgumentParser()
parser.add_argument('filename', help="the CMakeCache.txt of superbuild")
parser.add_argument('--yaml_filename', help="the CMakeCache.txt of superbuild", default="superbuild_config_info.yml")
parser.add_argument('--all', help="the CMakeCache.txt of superbuild", type=bool, default=True)
args = parser.parse_args()

if args.all:
    reg_expr = r"SUPERBUILD_.*:BOOL=.*"
else:
    reg_expr = r"SUPERBUILD_.*:BOOL=ON"

configuration = {'repos': []}
with open(args.filename, 'r') as f:
    for line in f.readlines():
        if re.match(reg_expr, line):
            repo, active = line.strip().replace("SUPERBUILD_", "").replace("BOOL=", "").split(':')
            configuration['repos'].append({'name': repo, 'active': active})

with open(args.yaml_filename, 'w') as outfile:
    yaml.dump(configuration, outfile, default_flow_style=False)
