# Bashargs

[![Makefile CI](https://github.com/ic-designer/bash-bashargs/actions/workflows/makefile.yml/badge.svg?branch=main)](https://github.com/ic-designer/bash-bashargs/actions/workflows/makefile.yml)

## Usage

The `bashargs` library can be used within a Makefile as follows.

```make
BASHARGS.SH := lib/bashargs/bashargs.sh
$(BASHARGS.SH):
	curl -sL https://github.com/ic-designer/bash-bashargs/archive/refs/tags/0.3.2.tar.gz | tar xz
	$(MAKE) -C bash-bashargs-0.3.1 install DESTDIR=$(CURDIR) LIBDIR=lib
	test -f $@
```
