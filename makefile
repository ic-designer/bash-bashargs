override VERSION:=0.1.0+20231228

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


# Config
.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules
SHELL = /usr/bin/env bash
.SHELLFLAGS += -e -o pipefail


# Paths
override DIR_BUILD:=.build
override DIR_BUILD_PKGS:=$(DIR_BUILD)/pkgs
override DIR_BUILD_TEST:=$(DIR_BUILD)/test


# Includes
include make/private.mk
