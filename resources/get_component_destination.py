#!/usr/bin/env python

import json
import os
from os import path
import hashlib
import sys


def get_component_destination(component, version):

    script_path = path.dirname(path.realpath(__file__))
    with open(f"{script_path}/software_sources.json", "r") as f:
        data = json.load(f)

    print(data[component][version]["destination"])


def main():
    args = sys.argv[1:]
    get_component_destination(args[0], args[1])


if __name__ == "__main__":
    main()
