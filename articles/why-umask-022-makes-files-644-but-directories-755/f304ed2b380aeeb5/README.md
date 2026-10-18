# Why umask 022 Makes Files 644 but Directories 755

Supporting source for https://networknuts.net/knowledge-base/why-umask-022-makes-files-644-but-directories-755/.

Tested runtime: Ubuntu 26.04 x86_64; 6 vCPU; about 12 GB RAM. Ubuntu Linux filesystem with Python and GNU find; temporary user-owned files only

Requirements: Linux, Python 3 and GNU find; a new empty working directory

Copy these files into a new disposable folder and run `python3 run.py`. The runner prints checks and writes details.txt. Remove only that disposable folder after inspecting the results.
