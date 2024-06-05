# Paths
DESTDIR =
PREFIX = $(HOME)/.local
LIBDIR = $(PREFIX)/lib
WORKDIR_ROOT := $(CURDIR)/.make

# Targets
.PHONY: all
## Builds the Bashargs libraries
all: private_all

.PHONY: check
## Runs the repository tests
check: private_test

.PHONY: clean
## Deletes all files created by Make
clean: private_clean
	@$(if $(wildcard .waxwing), rm -rfv .waxwing)

.PHONY: install
## Installs the Bashargs libraries to $(DESTDIR)/$(LIBDIR)/$(NAME)
install: private_install

.PHONY: mostlyclean
## Deletes only the build and test files created by Make
mostlyclean: private_mostlyclean

.PHONY: test
## Runs the repository tests
test: private_test

.PHONY: uninstall
## Uninstalls the Bashargs libraries from $(DESTDIR)/$(LIBDIR)/$(NAME)
uninstall: private_uninstall

# Includes
include make/private.mk
