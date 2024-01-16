PHONY: test-makefile
test-makefile: \
		test-install-destdir \
		test-install-libdir \
		test-install-prefix \
		test-uninstall-destdir \
		test-uninstall-libdir \
		test-uninstall-prefix \
		test-workdir-root


PHONY: test-install-destdir
test-install-destdir:
	$(MAKE) install DESTDIR=$(WORKDIR_TEST)/$@
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/bashargs/bashargs.sh

PHONY: test-install-libdir
test-install-libdir:
	$(MAKE) install DESTDIR=$(WORKDIR_TEST)/$@ LIBDIR=libdir
	test -f $(WORKDIR_TEST)/$@/libdir/bashargs/bashargs.sh

PHONY: test-install-prefix
test-install-prefix:
	$(MAKE) install DESTDIR=$(WORKDIR_TEST)/$@ PREFIX=prefix
	test -f $(WORKDIR_TEST)/$@/prefix/lib/bashargs/bashargs.sh


.PHONY: test-uninstall-destdir
test-uninstall-destdir: test-install-destdir
	$(MAKE) uninstall DESTDIR=$(WORKDIR_TEST)/$@
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/bashargs/bashargs.sh

PHONY: test-uninstall-libdir
test-uninstall-libdir: test-install-libdir
	$(MAKE) uninstall DESTDIR=$(WORKDIR_TEST)/$@ LIBDIR=libdir
	test ! -f $(WORKDIR_TEST)/$@/libdir/bashargs/bashargs.sh

PHONY: test-uninstall-prefix
test-uninstall-prefix: test-install-prefix
	$(MAKE) uninstall DESTDIR=$(WORKDIR_TEST)/$@ PREFIX=prefix
	test ! -f $(WORKDIR_TEST)/$@/prefix/lib/bashargs/bashargs.sh

PHONY: test-workdir-root
test-workdir-root:
	$(MAKE) all WORKDIR_ROOT=$(WORKDIR_TEST)/$@
	test -d $(WORKDIR_TEST)/$@/deps
	test -d $(WORKDIR_TEST)/$@/build
