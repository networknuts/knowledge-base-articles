# Why umask 022 Makes Files 644 but Directories 755

Supporting source for https://networknuts.net/knowledge-base/why-umask-022-makes-files-644-but-directories-755/.

Tested runtime: Ubuntu 26.04 LTS. Ubuntu Linux; Bash, GNU coreutils and find; temporary user-owned files only

Requirements: Linux, Bash, GNU coreutils and find; a new empty working directory

Follow the individual commands in the article in a new disposable folder. Optional full reproduction: `bash commands.sh`. For learning, follow the individual native commands and explanations in the article; any shell transcript is optional. Follow the supplied scoped cleanup instructions.
