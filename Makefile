.PHONY: test
GITHUB_ORG_URI := https://github.com/yaml
TEST_SUITE_URL := $(GITHUB_ORG_URI)/yaml-test-suite

default: help

help:
	@echo 'test  - Run the tests'
	@echo 'clean - Remove generated files'
	@echo 'help  - Show help'

test: data \
           libyaml-parser-emitter/libyaml-parser \
           libyaml-parser-emitter/libyaml-emitter
	prove -lv test

clean:
	rm -fr data libyaml-parser-emitter

data:
	git clone $(TEST_SUITE_URL) $@ --branch=$@

%/libyaml-parser %/libyaml-emitter: %
	(cd $<; make build)

libyaml-parser-emitter:
	git clone $(GITHUB_ORG_URI)/$@ $@
