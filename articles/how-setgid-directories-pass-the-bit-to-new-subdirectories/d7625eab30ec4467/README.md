# How Linux Setgid Directories Pass the Setgid Bit to New Subdirectories

This lab measures setgid-bit propagation on directories. It does not claim to test group ownership inheritance: the restricted runner uses one primary group, so a meaningful comparison between two different groups is unavailable here.

The commands create a disposable `setgid-sandbox` directory and write fresh runtime evidence to `details.txt` at the workspace root. They set an explicit umask, compare a setgid parent with a normal parent, capture the parent mode before and after clearing SGID, and create subdirectories to verify the change. With `umask 022`, a subdirectory created under `shared` before clearing SGID should normally show mode `2755`, while the comparison cases under `plain` and after `chmod g-s shared` should normally show `755`. These expected octal modes assume ordinary Linux `mkdir` behavior without default ACLs or other filesystem-specific inheritance rules. `details.txt` is produced from the actual run.

## Requirements

- Linux with Bash and GNU `stat`
- Write access to the current directory

## Reproduction

```sh
bash commands.sh
```

The checks verify both the setgid bit with `test -g` and the expected octal directory modes under the explicit `umask 022`. Default ACLs or special filesystem group-inheritance options can change those mode results; the lab assumes ordinary Linux filesystem semantics.

## Cleanup

```sh
rm -rf setgid-sandbox details.txt
```