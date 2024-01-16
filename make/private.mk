# Config
.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules

# Paths
DESTDIR =
PREFIX = $(HOME)/.local
LIBDIR = $(PREFIX)/lib
WORKDIR_ROOT := $(CURDIR)/.make

# Constants
override NAME := bashargs
override VERSION := $(shell git describe --always --dirty --broken 2> /dev/null)

override PKGSUBDIR = $(NAME)
override WORKDIR_BUILD = $(WORKDIR_ROOT)/build/$(NAME)/$(VERSION)
override WORKDIR_DEPS = $(WORKDIR_ROOT)/deps
override WORKDIR_TEST = $(WORKDIR_ROOT)/test/$(NAME)/$(VERSION)

# Includes
include make/deps.mk
include test/bashargs/test_bashargs.mk
include test/makefile/test_makefile.mk
-include $(BOXERBIRD.MK)

# Targets
.PHONY: private_all
private_all: $(WORKDIR_BUILD)/bashargs.sh
	@for f in $^; do test -f $${f}; done

$(WORKDIR_BUILD)/bashargs.sh: src/bashargs/bashargs.sh
	$(boxerbird::install-as-copy)


.PHONY: private_clean
private_clean:
	@echo "Cleaning directories:"
	@$(if $(wildcard $(WORKDIR_BUILD)), rm -rfv $(WORKDIR_BUILD))
	@$(if $(wildcard $(WORKDIR_DEPS)), rm -rfv $(WORKDIR_DEPS))
	@$(if $(wildcard $(WORKDIR_ROOT)), rm -rfv $(WORKDIR_ROOT))
	@$(if $(wildcard $(WORKDIR_TEST)), rm -rfv $(WORKDIR_TEST))
	@echo


.PHONY: private_install
private_install: $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/bashargs.sh

$(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/bashargs.sh: $(WORKDIR_BUILD)/bashargs.sh
	$(boxerbird::install-as-copy)


.PHONY: private_test
private_test: test-makefile test-bashargs
	@echo "INFO: Testing complete"
	@echo


.PHONY: private_uninstall
private_uninstall:
	@echo "Uninstalling $(NAME)"
	@\rm -rdfv $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR) 2> /dev/null || true
	@\rm -dv $(dir $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)) 2> /dev/null || true
	@\rm -dv $(DESTDIR)/$(LIBDIR) 2> /dev/null || true
