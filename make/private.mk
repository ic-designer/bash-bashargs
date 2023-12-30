# Required Paths
DIR_BUILD ?= $(error ERROR: Undefined variable DIR_BUILD)
DIR_BUILD_PKGS ?= $(error ERROR: Undefined variable DIR_BUILD_PKGS)
DIR_BUILD_TEST ?= $(error ERROR: Undefined variable DIR_BUILD_TEST)


# Includes
include make/extras.mk


# Dependencies
WAXWING:=$(DIR_BUILD_PKGS)/waxwing/bin/waxwing
$(WAXWING): |$(DIR_BUILD_PKGS)/.
	$(call git-clone-shallow, \
			git@github.com:ic-designer/waxwing.git, \
			$(DIR_BUILD_PKGS)/waxwing, \
			main)


# Private targets
.PHONY: private_test
private_test: \
		$(DIR_BUILD_TEST)/test-bashargs.merged.sh \
		$(WAXWING) \
		|$(DIR_BUILD_TEST)/.
	$(WAXWING) $(DIR_BUILD_TEST)

$(DIR_BUILD_TEST)/test-bashargs.merged.sh: \
		src/bashargs/bashargs.sh \
		$(shell find test/bashargs -name 'test_bashargs*.sh') \
		| $(DIR_BUILD_TEST)/.
	$(build-merged-script)


.PHONY: private_clean
private_clean:
	@echo "Cleaning directories: $(DIR_BUILD), $(DIR_BUILD_PKGS), $(DIR_BUILD_TEST)"
	$(if $(wildcard $(DIR_BUILD)), rm -rf $(DIR_BUILD))
	$(if $(wildcard $(DIR_BUILD_PKGS)), rm -rf $(DIR_BUILD_PKGS))
	$(if $(wildcard $(DIR_BUILD_TEST)), rm -rf $(DIR_BUILD_TEST))


.PHONY: private_pkg_list
private_pkg_list:
	$(call git-list-remotes, $(DIR_BUILD_PKGS))


.PHONY: private_pkg_override
private_pkg_override: REPO ?= $(error ERROR: Repo not defined. Please defined REPO=<repository>)
private_pkg_override: NAME ?= $(error ERROR: Name not defined. Please defined NAME=<repository>)
private_pkg_override:
	$(call git-clone-shallow, $(REPO), $(DIR_BUILD_PKGS)/$(NAME))
