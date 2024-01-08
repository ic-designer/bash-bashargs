# Constants
DESTDIR ?= $(error ERROR: Undefined variable DESTDIR)
PREFIX ?= $(error ERROR: Undefined variable PREFIX)
LIBDIR ?= $(error ERROR: Undefined variable LIBDIR)
NAME ?= $(error ERROR: Undefined variable NAME)
VERSION ?= $(error ERROR: Undefined variable VERSION)
WORKDIR_ROOT ?= $(error ERROR: Undefined variable WORKDIR_ROOT)
override PKGSUBDIR = $(NAME)/$(NAME)-$(VERSION)
override WORKDIR = $(WORKDIR_ROOT)
override WORKDIR_BUILD = $(WORKDIR)/build
override WORKDIR_DEPS = $(WORKDIR)/deps
override WORKDIR_TEST = $(WORKDIR)/test

# Includes
include make/extras.mk

# Dependencies
WAXWING:=$(WORKDIR_DEPS)/waxwing/bin/waxwing
$(WAXWING): |$(WORKDIR_DEPS)/.
	$(call git-clone-shallow, \
			git@github.com:ic-designer/waxwing.git, \
			$(WORKDIR_DEPS)/waxwing, \
			main)

# Targets
.PHONE: private_all
private_all: $(WORKDIR_BUILD)/bashargs.sh

$(WORKDIR_BUILD)/bashargs.sh: src/bashargs/bashargs.sh
	$(call install-as-copy)


.PHONY: private_clean
private_clean:
	@echo "Cleaning directories:"
	@$(if $(wildcard $(WORKDIR)), rm -rfv $(WORKDIR))
	@$(if $(wildcard $(WORKDIR_DEPS)), rm -rfv $(WORKDIR_DEPS))
	@$(if $(wildcard $(WORKDIR_ROOT)), rm -rfv $(WORKDIR_ROOT))
	@$(if $(wildcard $(WORKDIR_TEST)), rm -rfv $(WORKDIR_TEST))
	@echo


.PHONY: private_install
private_install: $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/bashargs.sh

$(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/bashargs.sh: $(WORKDIR_BUILD)/bashargs.sh
	$(call install-as-copy)


.PHONY: private_test
private_test: $(WAXWING) $(WORKDIR_TEST)/test-bashargs.sh
	$(WAXWING) $(WORKDIR_TEST)

$(WORKDIR_TEST)/test-bashargs.sh: \
		$(WORKDIR_TEST)/$(LIBDIR)/$(PKGSUBDIR)/bashargs.sh \
		$(shell find test/bashargs -name 'test_bashargs*.sh')
	$(build-bash-library)

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


.PHONY: private_pkg_list
private_pkg_list:
	$(call git-list-remotes, $(WORKDIR_DEPS))


.PHONY: private_pkg_override
private_pkg_override: REPO_NAME ?= $(error ERROR: Name not defined. Please defined REPO_NAME=<name>)
private_pkg_override: REPO_PATH ?= $(error ERROR: Repo not defined. Please defined REPO_PATH=<path>)
private_pkg_override:
	$(call git-clone-shallow, $(REPO_PATH), $(WORKDIR_DEPS)/$(REPO_NAME))
