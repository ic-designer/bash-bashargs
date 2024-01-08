define build-bash-library
	@echo 'Bulding library $@'
	@mkdir -p $(dir $@)
	@cat $^ > $@
	@echo
endef

define git-clone-shallow
	$(if $(wildcard $2), rm -rf $2)
	git clone -v --depth=1 --config advice.detachedHead=false $1 $2 $(if $3, --branch $3)
	@echo
endef

define git-list-remotes
	@for d in $(1)/*; do \
		echo "$${d} $$(git -C $${d} remote get-url origin --push)"; \
	done
endef

define install-as-copy
	@install -dv $(dir $@)
	@install -Sv $< $@
	test -f $@
	diff $@ $<
	@echo
endef


.PRECIOUS: %/.
%/. :
	@mkdir -p $@
