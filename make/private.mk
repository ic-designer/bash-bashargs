# Constants
NAME ?= $(error ERROR: Undefined variable NAME)
VERSION ?= $(error ERROR: Undefined variable VERSION)
WORKDIR_ROOT ?= $(error ERROR: Undefined variable WORKDIR_ROOT)
override WORKDIR = $(WORKDIR_ROOT)/$(NAME)-$(VERSION)
override WORKDIR_PKGS = $(WORKDIR)/pkgs
override WORKDIR_TEST = $(WORKDIR)/test

# Includes
include make/extras.mk

# Dependencies
WAXWING:=$(WORKDIR_PKGS)/waxwing/bin/waxwing
$(WAXWING): |$(WORKDIR_PKGS)/.
	$(call git-clone-shallow, \
			git@github.com:ic-designer/waxwing.git, \
			$(WORKDIR_PKGS)/waxwing, \
			main)

# Targets
.PHONY: private_clean
private_clean:
	@echo "Cleaning directories: $(WORKDIR_ROOT), $(WORKDIR), $(WORKDIR_PKGS), $(WORKDIR_TEST)"
	$(if $(wildcard $(WORKDIR)), rm -rf $(WORKDIR))
	$(if $(wildcard $(WORKDIR_PKGS)), rm -rf $(WORKDIR_PKGS))
	$(if $(wildcard $(WORKDIR_ROOT)), rm -rf $(WORKDIR_ROOT))
	$(if $(wildcard $(WORKDIR_TEST)), rm -rf $(WORKDIR_TEST))


.PHONY: private_pkg_list
private_pkg_list:
	$(call git-list-remotes, $(WORKDIR_PKGS))


.PHONY: private_pkg_override
private_pkg_override: REPO_NAME ?= $(error ERROR: Name not defined. Please defined REPO_NAME=<name>)
private_pkg_override: REPO_PATH ?= $(error ERROR: Repo not defined. Please defined REPO_PATH=<path>)
private_pkg_override:
	$(call git-clone-shallow, $(REPO_PATH), $(WORKDIR_PKGS)/$(REPO_NAME))


.PHONY: private_test
private_test: \
		$(WORKDIR_TEST)/test-bashargs.sh \
		$(WAXWING) \
		|$(WORKDIR_TEST)/.
	$(WAXWING) $(WORKDIR_TEST)

$(WORKDIR_TEST)/test-bashargs.sh: \
		src/bashargs/bashargs.sh \
		$(shell find test/bashargs -name 'test_bashargs*.sh') \
		| $(WORKDIR_TEST)/.
	$(build-bash-library)
