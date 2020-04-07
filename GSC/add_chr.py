import re
import sys
# file input
if len(sys.argv) !=3:
    print "Usage: python replace.py [infile] [outfile]"
    sys.exit(1)

infile = sys.argv[1]
outfile = sys.argv[2]


with open(infile, "r")as fin, open(outfile, "w")as fout:

    
    for line in fin:
        newline = "chr"+line
        fout.write(newline)
