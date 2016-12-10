#!/bin/bash

set -e
# set -x

if [[ $# -gt 0 ]]; then
  dirs=("$@")
else
  dirs=(`find data | grep '/test\.event$' | cut -d/ -f2 | sort`)
fi

for dir in "${dirs[@]}"; do
  dir="data/$dir"
  [[ -e "$dir/in.yaml" ]] || continue
  if [[ -f "$dir/skip" ]]; then
    if grep '^libyaml-parser$' "$dir/skip" &> /dev/null; then
      echo ">>> $dir - skipping..."
      continue
    fi
  fi
  echo ">>> $dir"
  tmpyaml="/tmp/yaml-test.yaml"
  tmpevent="/tmp/yaml-test.event"
  ./libyaml-emitter/libyaml-emitter "$dir/test.event" > "$tmpyaml" || {
    (
      set -x
      cat "$dir/in.yaml"
      cat "$dir/test.event"
    )
    exit 1
  }
  ./libyaml-parser/libyaml-parser "$tmpyaml" > "$tmpevent" || {
    (
      set -x
      cat "$dir/in.yaml"
      cat "$dir/test.event"
    )
    exit 1
  }
  ok=true
  output="$(${DIFF:-diff} -u $dir/test.event "$tmpevent")" || ok=false
  if ! $ok; then
    echo "$output"
    exit 1
  fi
done

rm "$tmpyaml"
rm "$tmpevent"

echo PASS

cat <<...

XXX

These emitter tests were run by bin/test-libyaml-emitter.sh which is really
just an exact copy of bin/test-libyaml-emitter.sh. ie Someone needs to write
bin/test-libyaml-emitter.sh.

After that we should change the test harness to use TAP and prove and
ingydotnet/test-more-bash.
...
