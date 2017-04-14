#!/bin/bash

set -e
set -u

./make.py metadata_rnc_2_0.template ../schemas/metadata.rnc
./make.py --lax metadata_rnc_2_0.template ../schemas/metadata-lax.rnc