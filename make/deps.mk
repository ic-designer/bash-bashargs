# Constants
WORKDIR_DEPS ?= $(error ERROR: Undefined variable WORKDIR_DEPS)

# Load Bowerbird Dependency Tools
BOWERBIRD_DEPS.MK := $(WORKDIR_DEPS)/BOWERBIRD_DEPS/bowerbird_deps.mk
$(BOWERBIRD_DEPS.MK):
	@curl --silent --show-error --fail --create-dirs -o $@ -L \
https://raw.githubusercontent.com/ic-designer/make-bowerbird-deps/\
a84d91d5d726ab8639b330b453a3d899556b480f/src/bowerbird-deps/bowerbird-deps.mk
include $(BOWERBIRD_DEPS.MK)

# Load Dependencies
$(eval $(call bowerbird::git-dependency,BOWERBIRD_TEST,https://github.com/ic-designer/make-bowerbird-test.git,main,bowerbird.mk))


BOXERBIRD_BRANCH := main
WAXWING_BRANCH := main

# Dependencies
override BOXERBIRD.MK := $(WORKDIR_DEPS)/make-boxerbird/boxerbird.mk
$(BOXERBIRD.MK):
	@echo "Loading Boxerbird..."
	git clone --config advice.detachedHead=false --depth 1 \
			https://github.com/ic-designer/make-boxerbird.git --branch $(BOXERBIRD_BRANCH) \
			$(WORKDIR_DEPS)/make-boxerbird
	@echo

override WAXWING := $(WORKDIR_DEPS)/bash-waxwing/bin/waxwing
$(WAXWING):
	@echo "Loading Waxwing..."
	git clone  --config advice.detachedHead=false --depth 1 \
			https://github.com/ic-designer/bash-waxwing.git --branch $(WAXWING_BRANCH) \
			$(WORKDIR_DEPS)/bash-waxwing
	@echo
