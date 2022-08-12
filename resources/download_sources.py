#!/usr/bin/env python

import json
import subprocess
import os
from os import path
import hashlib


def run_wget(source, destination):

    wget_command = f"wget -q -O {destination} {source}"
    print(f"run: {wget_command}")
    process = subprocess.Popen(
        wget_command,
        stdout = subprocess.PIPE,
        stderr = subprocess.PIPE,
        text = True,
        shell = True
    )
    std_out, std_err = process.communicate()
    print(std_out.strip(), std_err)


def get_hash_sha(source_path):

    with open(source_path, "rb") as f:
        bytes = f.read()
        readable_hash = hashlib.sha256(bytes).hexdigest();
        return readable_hash


def download_sources():

    script_path = path.dirname(path.realpath(__file__))
    with open(f"{script_path}/software_sources.json", "r") as f:
        data = json.load(f)

    for component, versions in data.items():
        for version, definition in versions.items():
            source = definition["source"]
            destination = definition["destination"]
            hash_sha = definition["sha256"]

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


def main():
    download_sources()


if __name__ == "__main__":
    main()
