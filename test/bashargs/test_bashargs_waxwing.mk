# Error Checking
DESTDIR ?= $(error ERROR: Undefined variable DESTDIR)
LIBDIR ?= $(error ERROR: Undefined variable LIBDIR)
PKGSUBDIR ?= $(error ERROR: Undefined variable PKGSUBDIR)
WAXWING ?= $(error ERROR: Undefined variable WAXWING)
WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)

# Targets
.PHONY: test-bashargs-waxwing
test-bashargs-waxwing: $(WAXWING) $(WORKDIR_TEST)/test-bashargs.sh
	$(WAXWING) $(WORKDIR_TEST)

$(WORKDIR_TEST)/test-bashargs.sh: \
		$(WORKDIR_TEST)/$(LIBDIR)/$(PKGSUBDIR)/bashargs.sh \
		$(shell find test/bashargs -name 'test_bashargs*.sh')
	$(call bowerbird::build-bash-library)

ifneq ($(DESTDIR),  $(WORKDIR_TEST))
$(WORKDIR_TEST)/$(LIBDIR)/$(PKGSUBDIR)/bashargs.sh: $(WORKDIR_BUILD)/bashargs.sh
	@$(MAKE) install DESTDIR=$(abspath $(WORKDIR_TEST))
endif
