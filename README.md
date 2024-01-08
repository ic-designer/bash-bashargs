# Bashargs

[![Makefile CI](https://github.com/ic-designer/bash-bashargs/actions/workflows/makefile.yml/badge.svg?branch=main)](https://github.com/ic-designer/bash-bashargs/actions/workflows/makefile.yml)

## Usage

The `bashargs` library can be loaded using following code snippet.

```make
BASHARGS := $(WORKDIR_BUILD)/lib/bashargs/bashargs.sh
$(BASHARGS):
	@echo "Installing bashargs..."
	git clone --config advice.detachedHead=false \
		git@github.com:ic-designer/bash-bashargs.git --branch 0.2.0 $(WORKDIR_DEPS)/bashargs
	$(MAKE) -C $(WORKDIR_DEPS)/bashargs install DESTDIR=$(abspath $(WORKDIR_BUILD)) LIBDIR=lib
	test -f $@
	@echo
```
