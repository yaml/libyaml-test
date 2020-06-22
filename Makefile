SHELL = bash

ifeq ($(LIBYAML_ROOT),)
  export LIBYAML_ROOT := libyaml
  export LIBYAML_REPO ?= https://github.com/yaml/libyaml
  export LIBYAML_COMMIT ?= master
else
  ifeq ($(wildcard $(LIBYAML_ROOT)/src/yaml_private.h),)
    $(error LIBYAML_ROOT=$(LIBYAML_ROOT) is not a libyaml repo clone directory)
  endif
endif

PARSER_TEST := $(LIBYAML_ROOT)/tests/run-parser-test-suite



.PHONY: test
test: test-suite

test-suite: $(PARSER_TEST) data
	( \
	  export LIBYAML_TEST_SUITE_ENV=$$(LIBYAML_TEST_SUITE_ENV=$(debug) ./bin/lookup env); \
	  [[ $$LIBYAML_TEST_SUITE_ENV ]] || exit 1; \
	  prove -v test/; \
	  [[ $$LIBYAML_TEST_SUITE_ENV != env/default ]] || \
	    ./bin/lookup default-warning \
	)

$(PARSER_TEST): $(LIBYAML_ROOT)
	( \
	  cd $< && \
	  ./bootstrap && \
	  ./configure && \
	  make all \
	)

$(LIBYAML_ROOT):
	git clone $(LIBYAML_REPO) $@
	( \
	  cd $@ && \
	  git reset --hard $(LIBYAML_COMMIT) \
	)

data:
	( \
	  data=$$(LIBYAML_TEST_SUITE_DEBUG=$(debug) ./bin/lookup data); repo=$${data%\ *}; commit=$${data/*\ /}; \
	  [[ $$repo && $$commit ]] || exit 1; \
	  echo "repo=$$repo commit=$$commit"; \
	  git clone $$repo $@; \
	  cd $@ && git reset --hard $$commit \
	)

clean:
	rm -fr data libyaml
	rm -f env/tmp-*
