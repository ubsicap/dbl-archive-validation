.DEFAULT_GOAL := all

all: clean rnc rng install

clean:
	@if [ -e ./metadata.rnc ]; then rm -f ./metadata.rnc; fi
	@if [ -e ./metadata.rng ]; then rm -f ./metadata.rng; fi
	@echo 'clean'

rnc:
	@python ./src/make.py ./src/metadata_rnc.template metadata.rnc;
	@echo 'completed rnc'

rng: rnc
	@java -jar ./trang.jar -I rnc -O rng ./metadata.rnc metadata.rng;
	#@rm ./metadata.rnc
	@echo 'completed rng'

install: rng
	@for type in text audio video print ebook; do \
		if [ ! -d ../../build/$${type} ]; then \
			mkdir -p ../../build/$${type}; \
		fi; \
	done
	@for DIR in ../../build/*; do \
		[ -d "$${DIR}" ] && mkdir -p "$${DIR}/2.0" && cp -f ./metadata.rng "$${DIR}/2.0/"; \
	done
	@rm ./metadata.rng
	@echo 'completed install'
