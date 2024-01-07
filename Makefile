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

.PHONY: pkg_list
pkg_list: private_pkg_list

.PHONY: pkg_override
pkg_override: private_pkg_override

.PHONY: test
test: private_test

#Includes
include make/private.mk
