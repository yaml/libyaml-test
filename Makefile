.PHONY: test
TEST_SUITE_URL := http://github.com/yaml/yaml-test-suite

default: help

help:
	@echo 'test  - Run the tests'
	@echo 'clean - Remove generated files'
	@echo 'help  - Show help'

test: data \
           libyaml-parser/libyaml-parser \
           libyaml-emitter/libyaml-emitter
	prove -lv test

clean:
	rm -fr data libyaml-parser libyaml-emitter

data:
	git clone $(TEST_SUITE_URL) $@ --branch=$@

libyaml-parser/% libyaml-emitter/%: %
	(cd $<; make build)

libyaml-parser libyaml-emitter:
	git clone https://github.com/ingydotnet/$@ $@
