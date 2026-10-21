#!/usr/bin/env bash
set -euo pipefail
# Run in a new disposable folder. Each subshell keeps its umask local.
(
  umask 022
  mkdir mask-022
  touch mask-022/sample.txt
  stat -c '%a %n' mask-022/sample.txt mask-022
)
(
  umask 027
  mkdir mask-027
  touch mask-027/sample.txt
  stat -c '%a %n' mask-027/sample.txt mask-027
)
(
  umask 077
  mkdir mask-077
  touch mask-077/sample.txt
  stat -c '%a %n' mask-077/sample.txt mask-077
)
test "$(stat -c %a mask-022/sample.txt)" = 644
test "$(stat -c %a mask-022)" = 755
test "$(stat -c %a mask-027/sample.txt)" = 640
test "$(stat -c %a mask-027)" = 750
test "$(stat -c %a mask-077/sample.txt)" = 600
test "$(stat -c %a mask-077)" = 700
chmod 644 mask-077/sample.txt
test "$(stat -c %a mask-077/sample.txt)" = 644
find mask-022 mask-027 mask-077 -printf '%m %p\n' | tee details.txt
printf 'PASS: native shell creation modes verified; chmod changed an existing file.\n'
