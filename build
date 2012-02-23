#!/bin/bash
#TODO: consider modifying tree to be version/type instead of type/version?

scriptpath=`readlink -f $0`
scriptdir=${scriptpath%/*}
sourcedir=$scriptdir/$1


usage () {
    echo "$0 version_dir"
    echo " "
    echo "compiles all rnc files from $scriptdir/<version_dir> to current dir."
}

if [ -z $1 ] ; then
    usage
    exit 0
fi

for rnc in `ls $sourcedir/*.rnc`
do
    base=${rnc##*/}
    base=${base%.rnc}
    java -jar $scriptdir/trang.jar -I rnc -O rng $rnc $base.rng
done
exit 0
java -jar trang.jar -I rnc -O rng usx.rnc usx.rng
java -jar trang.jar -I rnc -O rng metadata_project.rnc metadata_project.rng
java -jar trang.jar -I rnc -O rng usx_styles.rnc usx_styles.rng
