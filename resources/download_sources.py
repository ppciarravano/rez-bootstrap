#!/usr/bin/env python3

import json
import subprocess
import os
from os import path
import hashlib
import sys

#
# To download a single source:
# ${BOOTSTRAP_PATH}/resources/download_sources.py python 3.7.13
# To download all the sources:
# ${BOOTSTRAP_PATH}/resources/download_sources.py
#

def run_wget(source, destination):

    wget_command = f"wget -q -O {destination} {source}"
    print(f"run: {wget_command}")
    process = subprocess.Popen(
        wget_command,
        stdout = subprocess.PIPE,
        stderr = subprocess.PIPE,
        # text = True,
        shell = True
    )
    std_out, std_err = process.communicate()
    print(std_out.decode("utf-8").strip(), std_err.decode("utf-8") )


def get_hash_sha(source_path):

    with open(source_path, "rb") as f:
        bytes = f.read()
        readable_hash = hashlib.sha256(bytes).hexdigest();
        return readable_hash


def download_single_source(component, version, data):

    definition = data[component][version]
    source = definition["source"]
    destination = definition["destination"]
    hash_sha = definition["sha256"]

    if "REZ_REPO_PAYLOAD_DIR" in os.environ:
        rez_repo_payload_dir = os.environ["REZ_REPO_PAYLOAD_DIR"]
        destination = f"{rez_repo_payload_dir}/{destination}"

    print(f"Component: {component} {version}")
    if path.exists(destination):
        print(f"Component already downloaded: {component} {version}")
    else:
        destination_dirpath = path.dirname(destination)
        os.makedirs(destination_dirpath, exist_ok=True)
        print(f"download: {component} {version}")
        run_wget(source, destination)
        print(f"downloaded: {component} {version}")

    # verify hash
    hash_read = get_hash_sha(destination)
    if hash_sha != hash_read:
        raise Exception(f"Hash for component {component} {version} does not match: {hash_read}")
    else:
        print(f"Hash OK for component {component} {version}")


def download_sources(component=None, version=None):

    script_path = path.dirname(path.realpath(__file__))
    # TODO: change software_sources.json location
    with open(f"{script_path}/software_sources.json", "r") as f:
        data = json.load(f)

    if component and version:
        download_single_source(component, version, data)
    else:
        for component, versions in data.items():
            for version in versions.keys():
                download_single_source(component, version, data)


def main():
    args = sys.argv[1:]
    if len(args) == 2:
        download_sources(component=args[0], version=args[1])
    else:
        download_sources()

if __name__ == "__main__":
    main()
