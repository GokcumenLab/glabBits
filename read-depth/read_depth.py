#!/usr/bin/env python
# coding: utf-8
# Gokcumen Lab at UB
#
# Getting Neandertal/Denisovan read depth

import subprocess
import os.path
from os import path

# Modules
# python/py36-anaconda-5.3.1
# bedtools/2.23.0

# Constants
# Remaning files are generated with respect to the given CHR name
CHR = "19"
MANUAL_FILE_NAME = "TableS1.csv"

BAM_FILE = "AltaiNea.hg19_1000g.{chr}.dq.bam".format(chr=CHR)
GENERATED_BED_FILE = BAM_FILE.rsplit('.', 1)[0] + '.bed'
OUTPUT_FILE_NAME = "{chr}_del_count.csv".format(chr=CHR)
URL = "http://cdna.eva.mpg.de/neandertal/altai/AltaiNeandertal/bam/"
BAM_URL = URL + BAM_FILE
# AltaiNea.hg19_1000g.4.dq.bam AltaiNea.hg19_1000g.4.dq.bed
CMD_BAM_TO_BED = "bamToBed -i {bamfile} > {outputfile}".format(
    bamfile=BAM_FILE, outputfile=GENERATED_BED_FILE)
# TableS1.xls AltaiNea.hg19_1000g.3.dq.bed 4_del_count.txt
CMD_INTERSECT_BED = "intersectBed -a {manual_bed} -b {generated_bed} -c -wa -sorted > {outputfile}".format(
    manual_bed=MANUAL_FILE_NAME, generated_bed=GENERATED_BED_FILE, outputfile=OUTPUT_FILE_NAME)


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

# check BAM file and download if necessary
if(not path.exists(BAM_FILE)):
    print("downloading {} file ".format(BAM_FILE))
    runShellCmd("wget {}".format(BAM_URL))
else:
    print("File {} is already downloaded, using the same file without downloading again".format(BAM_FILE))

# check BED file and convert if necessary
if(not path.exists(GENERATED_BED_FILE)):
    print("converted {} file ".format(GENERATED_BED_FILE))
    # convert the downloaded BAM file into BED file
    runShellCmd(CMD_BAM_TO_BED)
else:
    print("File {} is already converted, using the same file without converting again".format(GENERATED_BED_FILE))

#  count the read depth within certain intervals
runShellCmd(CMD_INTERSECT_BED)
