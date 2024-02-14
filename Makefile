# Targets
.PHONY: all
all: private_all

.PHONY: check
check: private_test

.PHONY: clean
clean: private_clean

.PHONY: install
install: private_install

.PHONY: mostlyclean
mostlyclean: private_mostlyclean

.PHONY: test
test: private_test

.PHONY: uninstall
uninstall: private_uninstall

# Includes
include make/private.mk
