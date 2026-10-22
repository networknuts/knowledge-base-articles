# Reproduce the Kubernetes example

Use Docker Engine, kind 0.33.0, kubectl 1.37.x and Bash in a new empty directory. The example uses a disposable single-node kind cluster, not a production or managed cluster. Its API binds to localhost. Do not use production kubeconfig or credentials.

Read setup.sh and run its commands to create the named cluster ; the Pods pull their pinned public workload image. Export `KUBECONFIG="$PWD/lab-kubeconfig"` in your shell, then follow each kubectl command in commands.sh with the supplied YAML. The article explains the steps and observed results; executing the whole transcript is optional. Tests in commands.sh stop on a mismatch. No Python script is needed.

Read cleanup.sh and delete ONLY the named example cluster after testing. Never commit lab-kubeconfig or other credentials. The source archive intentionally excludes them.
