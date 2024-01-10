# Constants
WORKDIR_DEPS ?= $(error ERROR: Undefined variable WORKDIR_DEPS)

# Dependencies
override WAXWING := $(WORKDIR_DEPS)/bash-waxwing/bin/waxwing
$(WAXWING):
	@echo "Loading Waxwing..."
	git clone git@github.com:ic-designer/bash-waxwing.git $(WORKDIR_DEPS)/bash-waxwing
	@echo

override BOXERBIRD.MK := $(WORKDIR_DEPS)/make-boxerbird/boxerbird.mk
$(BOXERBIRD.MK):
	@echo "Loading Boxerbird..."
	git clone git@github.com:ic-designer/make-boxerbird.git $(WORKDIR_DEPS)/make-boxerbird
	@echo
