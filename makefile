
DIR_BUILD:=.make
DIR_SRC:=src
DIR_TEST:=test
DIR_DEPS:=deps

LIBS_SRC:=$(shell find $(DIR_SRC) -name '*.sh')
LIBS_TEST:=$(shell find $(DIR_TEST) -name 'test*.sh')

OBJ_TEST:=$(DIR_BUILD)/$(DIR_TEST)/test_bashargs_all.sh


WAXWING_PATH:=$(DIR_BUILD)/$(DIR_DEPS)/waxwing
WAXWING_BIN:=$(WAXWING_PATH)/bin/waxwing
WAXWING_URL:=git@github.com:jfredenburg/waxwing.git

# $(DIR_BUILD)/%: $(DIR_BUILD)/bash-bashargs/src/bashargs/bashargs.sh %.sh | $(DIR_BUILD)
# 	cat $^ > $@
# 	chmod u+x $@

# $(DIR_BUILD)/bash-bashargs/src/bashargs/bashargs.sh: | $(DIR_BUILD)
# 	rm -rf $(DIR_BUILD)/bash-bashargs
# 	git clone git@github.com:jfredenburg/bash-bashargs.git $(DIR_BUILD)/bash-bashargs


.PHONY: test
test: $(OBJ_TEST) $(WAXWING_BIN)
	$(WAXWING_BIN) $(DIR_BUILD)/$(DIR_TEST)/

$(OBJ_TEST): $(LIBS_SRC) $(LIBS_TEST) | $(dir $(OBJ_TEST))
	cat $^ > $@


# $(dir $(OBJ_TEST)):
# 	mkdir -p $(dir $(OBJ_TEST))

# $(BUILD_DEPS)

# $(DIR_BUILD):
# 	mkdir -p $(DIR_BUILD)

$(WAXWING_BIN): | $(WAXWING_PATH)/
	git clone  $(WAXWING_URL) $(WAXWING_PATH)

%/ :
	mkdir -p $@

clean:
	rm -rf $(DIR_BUILD)
