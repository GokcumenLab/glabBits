#!/usr/bin/env python
# coding: utf-8
# Gokcumen Lab at UB
#
# Atomic Python File

from og_core import *
from og_defs import *
import argparse


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("url", help="download url",
                        type=str)
    args = parser.parse_args()
    print(args.url)
    downloadFile(args.url)
