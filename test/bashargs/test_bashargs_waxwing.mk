# Error Checking
DESTDIR ?= $(error ERROR: Undefined variable DESTDIR)
LIBDIR ?= $(error ERROR: Undefined variable LIBDIR)
PKGSUBDIR ?= $(error ERROR: Undefined variable PKGSUBDIR)
WAXWING ?= $(error ERROR: Undefined variable WAXWING)
WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)

# Targets
test-bashargs-waxwing: $(WAXWING) $(WORKDIR_TEST)/test-bashargs.sh
	$(WAXWING) $(WORKDIR_TEST)

$(WORKDIR_TEST)/test-bashargs.sh: \
		$(WORKDIR_BUILD)/bashargs.sh \
		$(shell find test/bashargs -name 'test_bashargs*.sh')
	$(call bowerbird::build-bash-library)
