#!/usr/bin/env python3

import os
import sys
import getpass
import grp
import subprocess

def is_user_root():
    return getpass.getuser() == "root"

def is_user_in_docker_group():
    return "docker" in [g.gr_name for g in grp.getgrall() if getpass.getuser() in g.gr_mem]

def check_image_exists():
    ret = subprocess.run(["docker", "images", "-q", "binwalk"], capture_output=True)
    return ret.returncode == 0 and ret.stdout != None

def run(argv):
    return subprocess.run([
        "docker", "run", "--rm", "-v", f"{os.getcwd()}:/cwd", "binwalk:2.3.4"
    ] + argv).returncode

if __name__ == "__main__":

    if not (is_user_in_docker_group() or is_user_root()):
        print("you don't have permission.", file=sys.stderr)
        exit(-1)

    if not check_image_exists():
        print("binwalk docker image doesn't exists.", file=sys.stderr)
        exit(-1)

    run(sys.argv[1:])