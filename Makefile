UNRAR_VERSION := $(shell cat version.txt)

SOURCE_TARBALL := unrarsrc-$(UNRAR_VERSION).tar.gz
URL := "https://www.rarlab.com/rar/$(SOURCE_TARBALL)"
UNAME_ARCH := $(shell uname -m | tr '[:upper:]' '[:lower:]')

ifeq ($(shell uname -s),Darwin)
	SYS=macos
else ifeq ($(shell uname -s),Linux)
	SYS=linux
else
	SYS=$(shell uname -s| tr '[:upper:]' '[:lower:]')
endif

PACKAGENAME := libunrar-$(UNRAR_VERSION)_$(SYS)_$(UNAME_ARCH).zip

.PHONY: all clean

package:  unrar/libunrar.so
	@echo "Creating package $(PACKAGENAME)"
	mkdir -p packages
	zip -j packages/$(PACKAGENAME) unrar/libunrar.so 
    
unrar/libunrar.so: unrar/makefile
	@echo "Compiling library..."
	make -C unrar clean
	rm -f unrar/*.so unrar/*.a
	make -C unrar lib
    
unrar/makefile: tarballs/$(SOURCE_TARBALL)
	@echo "Un-taring source..."
	tar xzf tarballs/$(SOURCE_TARBALL)
    
tarballs/$(SOURCE_TARBALL): 
	@echo "Fetching source tarball ($(URL))from RARlabs site..."
	mkdir -p tarballs
	wget -P tarballs $(URL)
	@#cd tarballs && curl -O $(URL) 

clean:
	rm -rf tarballs
	rm -rf unrar
