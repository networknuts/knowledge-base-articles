#!/usr/bin/env bash
set -euo pipefail
# Only in a fresh directory outside any existing repository.
git init -q
git config user.name 'Example Author'
git config user.email 'author@example.invalid'
printf 'workers=1\n' > settings.txt
git add settings.txt
git commit -qm Baseline
printf 'workers=2\n' > settings.txt
git add settings.txt
printf 'workers=3\n' > settings.txt
git status --short -- settings.txt
test "$(git status --short -- settings.txt)" = 'MM settings.txt'
test "$(git show HEAD:settings.txt)" = 'workers=1'
test "$(git show :settings.txt)" = 'workers=2'
test "$(cat settings.txt)" = 'workers=3'
{
  printf '$ git diff --staged -- settings.txt\n'
  git diff --staged -- settings.txt
  printf '\n$ git diff -- settings.txt\n'
  git diff -- settings.txt
} | tee details.txt
git diff --staged -- settings.txt | grep -q '^+workers=2$'
git diff -- settings.txt | grep -q '^+workers=3$'
printf 'PASS: HEAD, index and working tree contain three different observed values.\n'
