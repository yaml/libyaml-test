libyaml-test
============

Test libyaml against external test suites

# Synopsis

```
make test
```

From libyaml master branch:

```
./bootstrap
./configure
make test-suite
```

# Description

This repo's job is to test libyaml against the `yaml-test-suite` and the test suites of projects that use libyaml, like PyYAML.
