#!/usr/bin/env python
# coding: utf-8
# Gokcumen Lab at UB
#
# Core functions
import subprocess
import os.path
from os import path

##############
# Directories
##############


def runShellCmd(cmd: str):
    '''
    Runs the given commmand on the shell
    '''
    print("Running command")
    print("--------------------------------")
    print(cmd)
    print("--------------------------------")

    result = subprocess.run(cmd,
                            shell=True,
                            # Probably don't forget these, too
                            check=True)
    if result.returncode != 0:
        print("FAILED! Unable to run {}".format(cmd))

    print(result)
    return result


def downloadFile(url):
    '''
    Downloads the given URL
    '''
    print("downloading {} file ".format(url))
    runShellCmd("wget {}".format(url))

def downloadAllFile(url):
    '''
    Downloads all file available under the given URL
    '''
    print("downloading {} file ".format(url))
    runShellCmd("wget --recursive --no-parent {}".format(url))
