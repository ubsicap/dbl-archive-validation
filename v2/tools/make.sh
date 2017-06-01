#!/bin/bash

set -e
set -u

srcDir=$1

echo "Make RNC"
echo "   metadata.rnc"
./makeRNC.py --quiet $srcDir/src/metadata_standalone_rnc_2_0.template $srcDir/schemas/metadata.rnc
echo "   metadata-lax.rnc"
./makeRNC.py --mode lax --quiet $srcDir/src/metadata_standalone_rnc_2_0.template $srcDir/schemas/metadata-lax.rnc
echo "   metadata-upload.rnc"
./makeRNC.py --mode upload --quiet $srcDir/src/metadata_standalone_rnc_2_0.template $srcDir/schemas/metadata-upload.rnc
echo "   job-spec-upload.rnc"
./makeRNC.py --mode upload --quiet $srcDir/src/job_specification_standalone_rnc_2_0.template $srcDir/schemas/job-spec-upload.rnc
echo "   dbl-xhtml.rnc"
./makeRNC.py --quiet $srcDir/src/xhtml_standalone_rnc_2_0.template $srcDir/schemas/dbl-xhtml.rnc

echo "Make RNG"
echo "   metadata.rng"
java -jar ./trang.jar -I rnc -O rng $srcDir/schemas/metadata.rnc $srcDir/schemas/metadata.rng
echo "   metadata-lax.rng"
java -jar ./trang.jar -I rnc -O rng $srcDir/schemas/metadata-lax.rnc $srcDir/schemas/metadata-lax.rng
echo "   metadata-upload.rng"
java -jar ./trang.jar -I rnc -O rng $srcDir/schemas/metadata-upload.rnc $srcDir/schemas/metadata-upload.rng
echo "   job-spec-upload.rnc"
java -jar ./trang.jar -I rnc -O rng $srcDir/schemas/job-spec-upload.rnc $srcDir/schemas/job-spec-upload.rng
echo "   dbl-xhtml.rnc"
java -jar ./trang.jar -I rnc -O rng $srcDir/schemas/dbl-xhtml.rnc $srcDir/schemas/dbl-xhtml.rng

echo "Make XSD"
echo "   dbl-xhtml.xsd"
java -jar ./trang.jar -I rnc -O xsd $srcDir/schemas/dbl-xhtml.rnc $srcDir/schemas/dbl-xhtml.xsd
