#!/usr/bin/env python3
import os
import sys
from as_json.metadata_as_json import MetadataAsJson


if len(sys.argv) != 2:
    raise Exception("USAGE: metadata_file_to_json.py <xml_file_path>")
path = os.path.abspath(sys.argv[1])
with open(path, "rb") as xml_in:
    xml_doc = xml_in.read()
maj = MetadataAsJson(xml_doc=xml_doc)
sys.stdout.write(maj.json())
