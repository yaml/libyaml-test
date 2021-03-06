#!/usr/bin/env bash

# shellcheck disable=1090,2034

root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

source "$root"/test-suite-runner.bash

check-test() {
  id=$1
  t=data/$id

  [[ " ${emitter_list[*]} " == *\ $id\ * ]] || return 1
  [[ -e $t/error ]] && return 1

  return 0
}

run-test() {
  dir=$1
  ok=true

  want=$dir/out.yaml
  [[ -e $want ]] || want="$dir/in.yaml"

  "${LIBYAML_ROOT:?}/tests/run-emitter-test-suite" "$dir/test.event" > /tmp/test.out || {
    (
      cat "$dir/test.event"
      cat "$want"
    ) | sed 's/^/# /'
  }

  output="$(${DIFF:-diff} -u "$want" /tmp/test.out)" || ok=false
}

run-tests "$@"
