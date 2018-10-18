#!/usr/bin/env python3

import sys
from lxml import etree

schema_path = "relaxng.rng"
doc_path = sys.argv[1]

schema_dom = etree.parse(schema_path)
validator = etree.RelaxNG(schema_dom)
doc_dom = etree.parse(doc_path)
validator.validate(doc_dom)
