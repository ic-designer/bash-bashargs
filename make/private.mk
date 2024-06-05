# Config
.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += --jobs
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKEFLAGS += --no-print-directory
MAKEFLAGS += --shuffle
MAKEFLAGS += --warn-undefined-variables

# Constants
NAME := bashargs
VERSION := $(shell git describe --always --dirty --broken 2> /dev/null)

# Paths
DESTDIR ?= $(error ERROR: Undefined variable DESTDIR)
LIBDIR ?= $(error ERROR: Undefined variable LIBDIR)
PREFIX ?= $(error ERROR: Undefined variable PREFIX)
WORKDIR_ROOT ?= $(error ERROR: Undefined variable WORKDIR_ROOT))
WORKDIR_DEPS = $(WORKDIR_ROOT)/deps
WORKDIR_BUILD = $(WORKDIR_ROOT)/build/$(NAME)/$(VERSION)
WORKDIR_TEST = $(WORKDIR_ROOT)/test/$(NAME)/$(VERSION)
override PKGSUBDIR = $(NAME)

# Includes
include make/deps.mk

# Targets
.PHONY: private_all
private_all: $(WORKDIR_BUILD)/bashargs.sh
	@for f in $^; do test -f $${f}; done

$(WORKDIR_BUILD)/bashargs.sh: src/bashargs/bashargs.sh
	$(bowerbird::install-as-copy)


.PHONY: private_clean
private_clean:
	@echo "INFO: Cleaning directories:"
	@$(if $(wildcard $(WORKDIR_BUILD)), rm -rfv $(WORKDIR_BUILD))
	@$(if $(wildcard $(WORKDIR_DEPS)), rm -rfv $(WORKDIR_DEPS))
	@$(if $(wildcard $(WORKDIR_ROOT)), rm -rfv $(WORKDIR_ROOT))
	@$(if $(wildcard $(WORKDIR_TEST)), rm -rfv $(WORKDIR_TEST))
	@echo "INFO: Cleaning complete"
	@echo


.PHONY: private_install
private_install: $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/bashargs.sh
	test -f $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/bashargs.sh
	@echo "INFO: Installation complete"
	@echo

$(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/bashargs.sh: $(WORKDIR_BUILD)/bashargs.sh
	$(bowerbird::install-as-copy)


.PHONY: private_mostlyclean
private_mostlyclean:
	@echo "INFO: Cleaning most directories:"
	@$(if $(wildcard $(WORKDIR_BUILD)), rm -rfv $(WORKDIR_BUILD))
	@$(if $(wildcard $(WORKDIR_TEST)), rm -rfv $(WORKDIR_TEST))
	@echo "INFO: Cleaning complete"
	@echo


.PHONY: private_test
private_test: test-bashargs-bowerbird test-bashargs-waxwing
	@echo "INFO: Testing complete"
	@echo
$(eval $(call bowerbird::generate-test-runner,test-bashargs-bowerbird,test,test*.mk))


.PHONY: private_uninstall
private_uninstall:
	@echo "Uninstalling $(NAME)"
	@\rm -rdfv $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR) 2> /dev/null || true
	@\rm -dv $(dir $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)) 2> /dev/null || true
	@\rm -dv $(DESTDIR)/$(LIBDIR) 2> /dev/null || true
	@echo "INFO: Uninstallation complete"
	@echo
