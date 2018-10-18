#!/bin/bash

set -e
set -u

version=${1:-"2_2"}
srcDir="../"$version

echo "Making v$version"

echo "Make RNC"
echo "   metadata.rnc"
./makeRNC.py --quiet $srcDir/src/metadata_standalone_rnc_$version.template $srcDir/schemas/metadata.rnc
echo "   metadata-upload.rnc"
./makeRNC.py --quiet --mode upload $srcDir/src/metadata_standalone_rnc_$version.template $srcDir/schemas/metadata-upload.rnc
echo "   metadata-template.rnc"
./makeRNC.py --quiet --mode template $srcDir/src/metadata_standalone_rnc_$version.template $srcDir/schemas/metadata-template.rnc
echo "   job-spec-upload.rnc"
./makeRNC.py --mode upload --quiet $srcDir/src/job_specification_standalone_rnc_$version.template $srcDir/schemas/job-spec-upload.rnc
echo "   dbl-xhtml.rnc"
./makeRNC.py --quiet $srcDir/src/xhtml_standalone_rnc_$version.template $srcDir/schemas/dbl-xhtml.rnc
echo "   publication-structure.rnc"
./makeRNC.py --quiet $srcDir/src/publication_structure_standalone_rnc_$version.template $srcDir/schemas/publication-structure.rnc
echo "   publication-division.rnc"
./makeRNC.py --quiet $srcDir/src/publication_division_standalone_rnc_$version.template $srcDir/schemas/publication-division.rnc
echo "   publication-content.rnc"
./makeRNC.py --quiet $srcDir/src/publication_content_standalone_rnc_$version.template $srcDir/schemas/publication-content.rnc

echo "Make RNG and validate"
echo "   metadata.rng"
java -jar ./trang.jar -I rnc -O rng $srcDir/schemas/metadata.rnc $srcDir/schemas/metadata.rng
xmllint --relaxng relaxng.rng -noout $srcDir/schemas/metadata.rng 2> /dev/null
./validate_rng.py $srcDir/schemas/metadata.rng
echo "   metadata-upload.rng"
java -jar ./trang.jar -I rnc -O rng $srcDir/schemas/metadata-upload.rnc $srcDir/schemas/metadata-upload.rng
xmllint --relaxng relaxng.rng -noout $srcDir/schemas/metadata-upload.rng 2> /dev/null
./validate_rng.py $srcDir/schemas/metadata-upload.rng
echo "   metadata-template.rng"
java -jar ./trang.jar -I rnc -O rng $srcDir/schemas/metadata-template.rnc $srcDir/schemas/metadata-template.rng
xmllint --relaxng relaxng.rng -noout $srcDir/schemas/metadata-template.rng 2> /dev/null
./validate_rng.py $srcDir/schemas/metadata-template.rng
echo "   job-spec-upload.rng"
java -jar ./trang.jar -I rnc -O rng $srcDir/schemas/job-spec-upload.rnc $srcDir/schemas/job-spec-upload.rng
xmllint --relaxng relaxng.rng -noout $srcDir/schemas/job-spec-upload.rng 2> /dev/null
./validate_rng.py $srcDir/schemas/job-spec-upload.rng
echo "   dbl-xhtml.rng"
java -jar ./trang.jar -I rnc -O rng $srcDir/schemas/dbl-xhtml.rnc $srcDir/schemas/dbl-xhtml.rng
xmllint --relaxng relaxng.rng -noout $srcDir/schemas/dbl-xhtml.rng 2> /dev/null
./validate_rng.py $srcDir/schemas/dbl-xhtml.rng
echo "   publication-structure.rng"
java -jar ./trang.jar -I rnc -O rng $srcDir/schemas/publication-structure.rnc $srcDir/schemas/publication-structure.rng
xmllint --relaxng relaxng.rng -noout $srcDir/schemas/publication-structure.rng 2> /dev/null
./validate_rng.py $srcDir/schemas/publication-structure.rng
echo "   publication-division.rng"
java -jar ./trang.jar -I rnc -O rng $srcDir/schemas/publication-division.rnc $srcDir/schemas/publication-division.rng
xmllint --relaxng relaxng.rng -noout $srcDir/schemas/publication-division.rng 2> /dev/null
./validate_rng.py $srcDir/schemas/publication-division.rng
echo "   publication-content.rng"
java -jar ./trang.jar -I rnc -O rng $srcDir/schemas/publication-content.rnc $srcDir/schemas/publication-content.rng
xmllint --relaxng relaxng.rng -noout $srcDir/schemas/publication-content.rng 2> /dev/null
./validate_rng.py $srcDir/schemas/publication-content.rng

echo "Make XSD"
echo "   dbl-xhtml.xsd"
java -jar ./trang.jar -I rnc -O xsd $srcDir/schemas/dbl-xhtml.rnc $srcDir/schemas/dbl-xhtml.xsd
