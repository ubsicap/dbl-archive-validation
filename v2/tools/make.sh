#!/bin/bash

set -e
set -u

srcDir=$1

./makeRNC.py --quiet $srcDir/src/metadata_rnc_2_0.template $srcDir/schemas/metadata.rnc
./makeRNC.py --mode lax --quiet $srcDir/src/metadata_rnc_2_0.template $srcDir/schemas/metadata-lax.rnc
./makeRNC.py --mode upload --quiet $srcDir/src/metadata_rnc_2_0.template $srcDir/schemas/metadata-upload.rnc