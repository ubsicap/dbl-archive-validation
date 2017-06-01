java -jar trang.jar -I rnc -O rng latest/dev/usx.rnc latest/dev/usx.rng
java -jar trang.jar -I rnc -O rng latest/prod/text/usx.rnc latest/prod/text/usx.rng
java -jar trang.jar -I rnc -O rng source/text/1.5/usx.rnc source/text/1.5/usx.rng
java -jar trang.jar -I rnc -O rng source/text/1.5/metadata.rnc source/text/1.5/metadata.rng
java -jar trang.jar -I rnc -O rng source/text/1.5/styles.rnc source/text/1.5/styles.rng

java -jar trang.jar -I rnc -O rng source/audio/1.2/license.rnc source/audio/1.2/license.rng
java -jar trang.jar -I rnc -O rng source/audio/1.2/metadata.rnc source/audio/1.2/metadata.rng