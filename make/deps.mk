# Constants
WORKDIR_DEPS ?= $(error ERROR: Undefined variable WORKDIR_DEPS)

# Dependencies
override WAXWING := $(WORKDIR_DEPS)/bash-waxwing/bin/waxwing
$(WAXWING):
	@echo "Loading Waxwing..."
	git clone --config advice.detachedHead=false \
		git@github.com:ic-designer/bash-waxwing.git --branch main $(WORKDIR_DEPS)/bash-waxwing
	@echo

override BOXERBIRD.MK := $(WORKDIR_DEPS)/make-boxerbird/boxerbird.mk
$(BOXERBIRD.MK):
	@echo "Loading Boxerbird..."
	git clone --config advice.detachedHead=false \
		git@github.com:ic-designer/make-boxerbird.git --branch 0.1.0 $(WORKDIR_DEPS)/make-boxerbird
	@echo
