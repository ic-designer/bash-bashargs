# Constants
DESTDIR ?= $(error ERROR: Undefined variable DESTDIR)
PREFIX ?= $(error ERROR: Undefined variable PREFIX)
LIBDIR ?= $(error ERROR: Undefined variable LIBDIR)

override NAME := bashargs
override PKGSUBDIR = $(NAME)
override VERSION := $(shell git describe --always --dirty --broken 2> /dev/null)
override WORKDIR = $(WORKDIR_ROOT)/$(NAME)/$(VERSION)
override WORKDIR_BUILD = $(WORKDIR)/build
override WORKDIR_DEPS = $(WORKDIR)/deps
override WORKDIR_ROOT := $(CURDIR)/.make
override WORKDIR_TEST = $(WORKDIR)/test

# Includes
BOXERBIRD.MK := $(WORKDIR_DEPS)/boxerbird/boxerbird.mk
$(BOXERBIRD.MK):
	@echo "Loading Boxerbird..."
	git clone --config advice.detachedHead=false \
		git@github.com:ic-designer/make-boxerbird.git --branch 0.1.0 $(dir $@)
	@echo
-include $(BOXERBIRD.MK)

# Dependencies
WAXWING := $(WORKDIR_DEPS)/waxwing/bin/waxwing
$(WAXWING):
	@echo "Loading Waxwing..."
	git clone --config advice.detachedHead=false \
		git@github.com:ic-designer/bash-waxwing.git --branch main $(WORKDIR_DEPS)/waxwing
	@echo

# Targets
.PHONE: private_all
private_all: $(WORKDIR_BUILD)/bashargs.sh
	@for f in $^; do test -f $${f}; done

$(WORKDIR_BUILD)/bashargs.sh: src/bashargs/bashargs.sh
	$(boxerbird::install-as-copy)


.PHONY: private_clean
private_clean:
	@echo "Cleaning directories:"
	@$(if $(wildcard $(WORKDIR)), rm -rfv $(WORKDIR))
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
private_test: $(WAXWING) $(WORKDIR_TEST)/test-bashargs.sh
	$(WAXWING) $(WORKDIR_TEST)

$(WORKDIR_TEST)/test-bashargs.sh: \
		$(WORKDIR_TEST)/$(LIBDIR)/$(PKGSUBDIR)/bashargs.sh \
		$(shell find test/bashargs -name 'test_bashargs*.sh')
	$(boxerbird::build-bash-library)

ifneq ($(DESTDIR),  $(WORKDIR_TEST))
$(WORKDIR_TEST)/$(LIBDIR)/$(PKGSUBDIR)/bashargs.sh:
	@$(MAKE) install DESTDIR=$(abspath $(WORKDIR_TEST))
endif


.PHONY: private_uninstall
private_uninstall:
	@echo "Uninstalling $(NAME)"
	@\rm -rdfv $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR) 2> /dev/null || true
	@\rm -dv $(dir $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)) 2> /dev/null || true
	@\rm -dv $(DESTDIR)/$(LIBDIR) 2> /dev/null || true
