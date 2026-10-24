#!/usr/bin/env bash
set -euo pipefail
# Removes ONLY this disposable example cluster, including its workloads.
kind delete cluster --name nn-blog-lab
rm -f lab-kubeconfig
