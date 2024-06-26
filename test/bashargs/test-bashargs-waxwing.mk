# Error Checking
WAXWING ?= $(error ERROR: Undefined variable WAXWING)
WORKDIR_BUILD ?= $(error ERROR: Undefined variable WORKDIR_TEST)
WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)

# Targets
.SECONDEXPANSION:
test-bashargs-waxwing: $$(WAXWING) $$(WORKDIR_TEST)/$$@/test-bashargs.sh
	$(WAXWING) $(WORKDIR_TEST)/$@

$(WORKDIR_TEST)/%/test-bashargs.sh: \
		$(WORKDIR_BUILD)/bashargs.sh \
		$(shell find test -name 'test*.sh')
	$(call bowerbird::build-bash-library)
