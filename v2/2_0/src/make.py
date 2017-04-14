#!/usr/bin/env python

import argparse
import sys
import re
import os

# Check cli args

parser = argparse.ArgumentParser(description="Assemble RelaxNG compact schema from components")
parser.add_argument("input", type=str, help="input file")
parser.add_argument("output", type=str, help="output file")
parser.add_argument("--lax", dest="lax", help="lax text", action="store_true")
parser.add_argument("--strict", dest="lax", help="strict text", action="store_false")
parser.set_defaults(lax=False)
args = parser.parse_args()

inputFilename = args.input
outputFilename = args.output
lax = args.lax
fileContents = ""
directory = os.path.dirname(os.path.realpath(__file__))

# Do repeated substitution, avoiding duplicates
inserted = {}
subRE = re.compile(r"%%insert ([A-Za-z0-9_.-]+)%%")
with open(inputFilename, 'r') as inputFileHandle:
   fileContents = inputFileHandle.read()
   match = re.search(subRE, fileContents)
   while match:
      insertFilename = match.group(1)
      if insertFilename in inserted:
         print "   " + "skipping " + insertFilename + " (already inserted)"
         fileContents = re.sub(match.group(0), "", fileContents, count=1)
      else:
         inserted[insertFilename] = True
         if lax:
            insertFilename = re.sub("_text_", "_lax_text_", insertFilename)
         if not(os.path.exists(os.path.join(directory, insertFilename))):
            print("ERROR: could not find file '{0}' during insert".format(insertFilename))
            sys.exit(1) 
         print "   " + "inserting " + insertFilename
         fileContents = re.sub(match.group(0), open(os.path.join(directory, insertFilename), "r").read(), fileContents, count=1)
      match = re.search(subRE, fileContents)

# Tidy whitespace
fileContents = re.sub(" +\n", "\n", fileContents)
fileContents = re.sub("\n( *\n)+", "\n\n", fileContents)

# Write out completed schema
with open(outputFilename, 'w') as outputFileHandle:
   outputFileHandle.write(fileContents)
