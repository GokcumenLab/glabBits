#!/usr/bin/env python
# coding: utf-8
# Gokcumen Lab at UB
#
# Getting Neandertal/Denisovan read depth

import subprocess

# bedtools/2.20.1
# chr4 as an example
# AltaiNea.hg19_1000g.4.dq.bam AltaiNea.hg19_1000g.4.dq.bed
CMD_BAM_TO_BED = "bamToBed -i {bamfile} > {outputfile}"
# TableS1.xls AltaiNea.hg19_1000g.3.dq.bed 4_del_count.txt
CMD_INTERSECT_BED = "intersectBed -a {manual_bed} -b {generated_bed} -c -wa -sorted > {outputfile}"


def runShellCmd(cmd: str):
    '''
    Runs the given commmand on the shell
    '''
    print(cmd)

    result = subprocess.run(cmd,
                            shell=True,
                            # Probably don't forget these, too
                            check=True)
    if result.returncode != 0:
        print("FAILED! Unable to run {}".format(cmd))

    print(result)
    return result


list_files = subprocess.run(["ls", "-l"])
print("The exit code was: %d" % list_files.returncode)

# convert the downloaded BAM file into BED file
cmd_to_bed = CMD_BAM_TO_BED.format(
    bamfile="AltaiNea.hg19_1000g.19.dq.bam", outputfile="AltaiNea.hg19_1000g.19.dq.bed")
runShellCmd(cmd_to_bed)

#  count the read depth within certain intervals
cmd_to_intersect = CMD_INTERSECT_BED.format(
    manual_bed="TableS1.csv", generated_bed="AltaiNea.hg19_1000g.19.dq.bed", outputfile="19_del_count.txt")
print(cmd_to_intersect)
runShellCmd(cmd_to_intersect)
