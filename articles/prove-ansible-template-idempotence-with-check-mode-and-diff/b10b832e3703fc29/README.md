# Prove Ansible Template Idempotence with Check Mode and Diff

Supporting source for https://networknuts.net/knowledge-base/prove-ansible-template-idempotence-with-check-mode-and-diff/.

Tested runtime: Ubuntu 26.04 x86_64; 6 vCPU; about 12 GB RAM. Ubuntu; ansible-core and Python; localhost connection, no sudo and no service reload

Requirements: Python 3 and ansible-core; a new empty working directory

Copy these files into a new disposable folder and run `python3 run.py`. The runner prints checks and writes details.txt. Remove only that disposable folder after inspecting the results.
