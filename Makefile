# Config
.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules

# Constants
override NAME := bashargs
override VERSION := $(shell git describe --always --dirty --broken)
override WORKDIR_ROOT := $(CURDIR)/.make

#Targets
.PHONY: check
check: private_test

.PHONY: clean
clean: private_clean

.PHONY: test
test: private_test

#Includes
include make/private.mk
