#!/bin/bash

set -e
set -u

./make.py --quiet metadata_rnc_2_0.template ../schemas/metadata.rnc
./make.py --lax --quiet metadata_rnc_2_0.template ../schemas/metadata-lax.rnc