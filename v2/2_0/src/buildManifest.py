#!/usr/bin/env python

import sys
import os
import hashlib

if (len(sys.argv) > 3) or (len(sys.argv) < 2):
	print("USAGE: python " + sys.argv[0] + " <topLevelDirPath> [includeProgress (True/False)]")
	sys.exit(1)

if (len(sys.argv) == 3) and (sys.argv[2] != "True") and (sys.argv[2] != "False"):
	print("USAGE: python " + sys.argv[0] + " <topLevelDirPath> [includeProgress (True/False)]")
	sys.exit(1)

topLevelDir = sys.argv[1]
includeProgress = False

mimeType = {}
mimeType["xml"] = "application/xml"
mimeType["pdf"] = "application/pdf"
mimeType["txt"] = "text/plain"
mimeType["py"] = "text/plain"
mimeType["SFM"] = "text/plain"
mimeType["ini"] = "text/plain"
mimeType["ini"] = "text/plain"
mimeType["indd"] = "application/x-indesign"
mimeType["ttf"] = "application/x-font-ttf"
mimeType["jpg"] = "image/jpeg"

def walkTree(dir):
	for i in os.listdir(dir):
		iPath = dir + "/" + i
		if os.path.isdir(iPath):
			sys.stdout.write("<container uri=\"" + i  + "\">\n")
			walkTree(iPath)
			sys.stdout.write("</container>\n")
		else:
			fileContents = open(iPath, "r").read()
			md5 = hashlib.md5(fileContents).hexdigest()
			suffix = i.split(".")[1]
			sys.stdout.write("<resource uri=\"" + i + "\" size=\"" + str(os.stat(iPath).st_size) + "\" checksum=\"" + md5 + "\" mimeType=\"" + mimeType.get(suffix, "text/plain") + "\"")
			if includeProgress:
				sys.stdout.write(" progress=\"4\"")
			sys.stdout.write("/>\n")

if (len(sys.argv) == 3) and (sys.argv[2] == "True"):
	includeProgress = True

walkTree(topLevelDir)
