#!/usr/bin/env python3

import os
import sys
import subprocess

def check_image_exists():
    ret = subprocess.run(["docker", "images", "-q", "binwalk"], capture_output=True)
    return ret.returncode == 0 and ret.stdout != None

def run(argv):
    return subprocess.run([
        "docker", "run", "--platform", "linux/amd64", "--rm", "-v", f"{os.getcwd()}:/cwd", "binwalk:2.3.4"
    ] + argv).returncode

if __name__ == "__main__":

    if not check_image_exists():
        print("binwalk docker image doesn't exists.", file=sys.stderr)
        exit(-1)

    run(sys.argv[1:])
