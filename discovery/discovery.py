#!/usr/bin/env python
# coding: utf-8
# Gokcumen Lab at UB
#
# Executes discovery process of deletions
# Sample command
# python discovery.py --ref human_v38_cnvr.fasta --unmasked-ref human_v38.fasta --aln /projects/academic/omergokc/ogshared/ancient/AltaiNea.hg19_1000g.22.dq.bam --conf human_v38_cnvr.cnvr --gene human_v38.nr.genes.bed
import sys
sys.path.insert(0, "/projects/academic/omergokc/ogshared/software/python/common/")

from og_core import *
from og_defs import *
import argparse


if __name__ == '__main__':
    parser = argparse.ArgumentParser(allow_abbrev=False)
    parser.add_argument("--ref", help="Ref file",
                        type=str)
    parser.add_argument("--unmasked-ref", help="Unmasked ref file",
                        type=str)
    parser.add_argument("--aln", help="aln-input BAM file",
                        type=str)
    parser.add_argument("--conf", help="cnvr conf file",
                        type=str)
    parser.add_argument("--gene", help="genes BED file",
                        type=str)
    args = parser.parse_args()
    print(vars(args))

    sys.path.append(SOFTWARE_CANAVAR_PATH)

    # prepare the command
    command = "mrcanavar-auto --ref " + args.ref + " --unmasked-ref " + args.unmasked_ref + \
        " --aln-input " + args.aln + " --conf " + args.conf + \
        " --gene " + args.gene + " --threads 32 --no-sam"
    runShellCmd(command)
