.DEFAULT_GOAL := all

all: clean build install

clean:
	if [[ -e ./metadata.rnc ]]; then rm -f ./metadata.rnc; fi
	if [[ -e ./metadata.rng ]]; then rm -f ./metadata.rng; fi

build:
	python2 ./make/make.py ./make/metadata_rnc.template metadata.rnc;
	java -jar ./trang.jar -I rnc -O rng ./metadata.rnc metadata.rng;

install: