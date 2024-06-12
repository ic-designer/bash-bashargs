# Constants
WORKDIR_DEPS ?= $(error ERROR: Undefined variable WORKDIR_DEPS)

# Load Bowerbird Dependency Tools
BOWERBIRD_DEPS.MK := $(WORKDIR_DEPS)/bowerbird-deps/bowerbird_deps.mk
$(BOWERBIRD_DEPS.MK):
	@curl --silent --show-error --fail --create-dirs -o $@ -L https://raw.githubusercontent.com/ic-designer/make-bowerbird-deps/main/src/bowerbird-deps/bowerbird-deps.mk
include $(BOWERBIRD_DEPS.MK)

# Bowerbird Compatible Dependencies
ifdef bowerbird::git-dependency
    $(eval $(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-bash-builder,\
            https://github.com/ic-designer/make-bowerbird-bash-builder.git,main,bowerbird.mk))
    $(eval $(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-githooks,\
            https://github.com/ic-designer/make-bowerbird-githooks.git,main,bowerbird.mk))
    $(eval $(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-help,\
            https://github.com/ic-designer/make-bowerbird-help.git,main,bowerbird.mk))
    $(eval $(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-install-tools,\
            https://github.com/ic-designer/make-bowerbird-install-tools.git,main,bowerbird.mk))
    $(eval $(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-test,\
            https://github.com/ic-designer/make-bowerbird-test.git,main,bowerbird.mk))
endif

# Other Dependencies
WAXWING_BRANCH := main
WAXWING = $(WORKDIR_DEPS)/bash-waxwing/bin/waxwing
.PRECIOUS: $(WAXWING)
$(WAXWING):
	@echo "INFO: Building $@..."
	@git clone  --config advice.detachedHead=false --depth 1 https://github.com/ic-designer/bash-waxwing.git --branch $(WAXWING_BRANCH) $(WORKDIR_DEPS)/bash-waxwing
	@test -f $@
	@echo "INFO: Build $@ complete."
	@echo
