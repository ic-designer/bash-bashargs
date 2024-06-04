test-install-destdir:
	$(MAKE) install DESTDIR=$(WORKDIR_TEST)/$@
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/bashargs/bashargs.sh

test-install-libdir:
	$(MAKE) install DESTDIR=$(WORKDIR_TEST)/$@ LIBDIR=libdir
	test -f $(WORKDIR_TEST)/$@/libdir/bashargs/bashargs.sh

test-install-prefix:
	$(MAKE) install DESTDIR=$(WORKDIR_TEST)/$@ PREFIX=prefix
	test -f $(WORKDIR_TEST)/$@/prefix/lib/bashargs/bashargs.sh


test-uninstall-destdir: test-install-destdir
	$(MAKE) uninstall DESTDIR=$(WORKDIR_TEST)/$@
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/bashargs/bashargs.sh

test-uninstall-libdir: test-install-libdir
	$(MAKE) uninstall DESTDIR=$(WORKDIR_TEST)/$@ LIBDIR=libdir
	test ! -f $(WORKDIR_TEST)/$@/libdir/bashargs/bashargs.sh

test-uninstall-prefix: test-install-prefix
	$(MAKE) uninstall DESTDIR=$(WORKDIR_TEST)/$@ PREFIX=prefix
	test ! -f $(WORKDIR_TEST)/$@/prefix/lib/bashargs/bashargs.sh

test-workdir-root:
	$(MAKE) all WORKDIR_ROOT=$(WORKDIR_TEST)/$@
	test -d $(WORKDIR_TEST)/$@/deps
	test -d $(WORKDIR_TEST)/$@/build
