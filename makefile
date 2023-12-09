
DIR_BUILD:=.make
DIR_SRC:=src
DIR_TEST:=test

DIR_BUILD_DEPS:=$(DIR_BUILD)/deps
DIR_BUILD_TEST:=$(DIR_BUILD)/test

LIBS_SRC:=$(shell find $(DIR_SRC) -name '*.sh')
LIBS_TEST:=$(shell find $(DIR_TEST) -name 'test*.sh')
OBJ_TEST_ALL:=$(DIR_BUILD_TEST)/test_bashargs_all.sh


WAXWING_PATH:=$(DIR_BUILD_DEPS)/waxwing
WAXWING_BIN:=$(WAXWING_PATH)/bin/waxwing
WAXWING_URL:=git@github.com:jfredenburg/waxwing.git
$(WAXWING_BIN): | $(WAXWING_PATH)/.
	git clone  $(WAXWING_URL) $(WAXWING_PATH)


.DELETE_ON_ERROR:
.PHONY: test
test: $(OBJ_TEST_ALL) $(WAXWING_BIN)
	$(WAXWING_BIN) $(dir $(OBJ_TEST_ALL))

$(OBJ_TEST_ALL): $(LIBS_SRC) $(LIBS_TEST) | $(dir $(OBJ_TEST_ALL))/.
	cat $^ > $@

%/. :
	mkdir -p $@

clean:
	rm -rf $(DIR_BUILD)
