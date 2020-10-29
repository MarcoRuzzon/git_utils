#!/usr/bin/env python

import argparse
import yaml

parser = argparse.ArgumentParser()
parser.add_argument('filename', help="the yaml file containing git repos info")
args = parser.parse_args()

with open(args.filename) as file:
    try:
        info = yaml.safe_load(file)

    except Exception as e:
        raise Exception('error in yaml parsing')

template = "set({}_TAG {})\n"
with open('ProjectsTags.cmake', "w") as f:
    for item in info['projects']:
        f.write(template.format(item['name'], item['commit']))
