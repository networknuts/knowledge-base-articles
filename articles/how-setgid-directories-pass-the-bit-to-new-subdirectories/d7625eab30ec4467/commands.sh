#!/usr/bin/env bash
set -euo pipefail
umask 022

root_dir="$PWD"
sandbox="setgid-sandbox"
workdir="$sandbox/setgid-lab"
details="$root_dir/details.txt"
rm -rf "$sandbox"
mkdir -p "$workdir"
cd "$workdir"

mkdir shared plain
chmod 2775 shared
chmod 0775 plain

before_clear_parent_mode="$(stat -c '%a' shared)"
[ "$before_clear_parent_mode" = 2775 ]
before_clear_parent_line="$(stat -c 'shared before-clear %a %A' shared)"

mkdir shared/nested_before_clear
mkdir plain/nested_before_clear

shared_has_sgid=false
plain_has_sgid=false
shared_child_has_sgid=false
plain_child_has_sgid=false
test -g shared && shared_has_sgid=true
test -g plain && plain_has_sgid=true
test -g shared/nested_before_clear && shared_child_has_sgid=true
test -g plain/nested_before_clear && plain_child_has_sgid=true

shared_child_mode="$(stat -c '%a' shared/nested_before_clear)"
plain_child_mode="$(stat -c '%a' plain/nested_before_clear)"

[ "$shared_has_sgid" = true ]
[ "$plain_has_sgid" = false ]
[ "$shared_child_has_sgid" = true ]
[ "$plain_child_has_sgid" = false ]
[ "$shared_child_mode" = 2755 ]
[ "$plain_child_mode" = 755 ]

chmod g-s shared
after_clear_parent_mode="$(stat -c '%a' shared)"
[ "$after_clear_parent_mode" = 775 ]

shared_after_clear=false
test -g shared && shared_after_clear=true
existing_child_after_clear=false
test -g shared/nested_before_clear && existing_child_after_clear=true
existing_child_after_clear_mode="$(stat -c '%a' shared/nested_before_clear)"
[ "$existing_child_after_clear" = true ]
[ "$existing_child_after_clear_mode" = 2755 ]

mkdir shared/nested_after_clear
new_child_has_sgid=false
test -g shared/nested_after_clear && new_child_has_sgid=true
new_child_mode="$(stat -c '%a' shared/nested_after_clear)"
[ "$new_child_mode" = 755 ]
[ "$new_child_has_sgid" = false ]

{
  printf '%s\n' "$before_clear_parent_line"
  printf 'effective_uid=%s\n' "$(id -u)"
  printf 'effective_gid=%s\n' "$(id -g)"
  printf 'before_clear_parent_mode=%s\n' "$before_clear_parent_mode"
  printf 'after_clear_parent_mode=%s\n' "$after_clear_parent_mode"
  printf 'shared_parent_mode=%s\n' "$(stat -c '%a' shared)"
  printf 'plain_parent_mode=%s\n' "$(stat -c '%a' plain)"
  stat -c 'shared/nested_before_clear %a %A' shared/nested_before_clear
  stat -c 'shared/nested_before_clear_after_clear %a %A' shared/nested_before_clear
  stat -c 'plain/nested_before_clear %a %A' plain/nested_before_clear
  stat -c 'shared/nested_after_clear %a %A' shared/nested_after_clear
  printf 'shared_child_sgid=%s\n' "$shared_child_has_sgid"
  printf 'plain_child_sgid=%s\n' "$plain_child_has_sgid"
  printf 'shared_child_mode=%s\n' "$shared_child_mode"
  printf 'plain_child_mode=%s\n' "$plain_child_mode"
  printf 'existing_child_sgid_after_clear=%s\n' "$existing_child_after_clear"
  printf 'existing_child_mode_after_clear=%s\n' "$existing_child_after_clear_mode"
  printf 'parent_sgid_after_clear=%s\n' "$shared_after_clear"
  printf 'new_child_sgid_after_clear=%s\n' "$new_child_has_sgid"
  printf 'new_child_mode_after_clear=%s\n' "$new_child_mode"
  printf 'bounded_command_evidence=find %s -maxdepth 3 -type d | sort\n' "$root_dir/$workdir"
  printf 'bounded_command_evidence_start\n'
  find "$root_dir/$workdir" -maxdepth 3 -type d | sort
  printf 'bounded_command_evidence_end\n'
  printf 'PASS: directory setgid-bit propagation and clearing verified\n'
} > "$details"
cat "$details"
