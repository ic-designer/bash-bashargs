test-install-destdir:
	$(call bashargs::test-installer::install-helper)

test-install-libdir: LIBDIR=libdir
test-install-libdir:
	test "$(LIBDIR)" = "libdir"
	$(call bashargs::test-installer::install-helper)

test-install-prefix: PREFIX=prefix
test-install-prefix:
	test "$(PREFIX)" = "prefix"
	$(call bashargs::test-installer::install-helper)

test-uninstall-destdir:
	$(call bashargs::test-installer::install-helper)
	$(call bashargs::test-installer::uninstall-helper)

test-uninstall-libdir: LIBDIR=libdir
test-uninstall-libdir:
	test "$(LIBDIR)" = "libdir"
	$(call bashargs::test-installer::install-helper)
	$(call bashargs::test-installer::uninstall-helper)

test-uninstall-prefix: PREFIX=prefix
test-uninstall-prefix:
	test "$(PREFIX)" = "prefix"
	$(call bashargs::test-installer::install-helper)
	$(call bashargs::test-installer::uninstall-helper)


define bashargs::test-installer::install-helper
	$(MAKE) install \
			DESTDIR=$(WORKDIR_TEST)/$@ \
			PREFIX=$(PREFIX) \
			LIBDIR=$(LIBDIR) \
			2>/dev/null
	test -f $(WORKDIR_TEST)/$@/$(LIBDIR)/$(PKGSUBDIR)/bashargs.sh
endef

define bashargs::test-installer::uninstall-helper
	$(MAKE) uninstall \
			DESTDIR=$(WORKDIR_TEST)/$@ \
			PREFIX=$(PREFIX) \
			LIBDIR=$(LIBDIR) \
			2>/dev/null
	test ! -f $(WORKDIR_TEST)/$@/$(LIBDIR)/$(PKGSUBDIR)/bashargs.sh
endef
