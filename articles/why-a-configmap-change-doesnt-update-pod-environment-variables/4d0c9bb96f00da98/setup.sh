#!/usr/bin/env bash
set -euo pipefail
export KUBECONFIG="$PWD/lab-kubeconfig"
# Refuse to replace a pre-existing cluster with this name.
if kind get clusters 2>/dev/null | grep -qx nn-blog-lab; then
  echo 'Cluster nn-blog-lab already exists; choose a clean lab before proceeding.' >&2
  exit 1
fi
kind create cluster --name nn-blog-lab --config kind-config.yaml --kubeconfig "$KUBECONFIG" --wait 180s
kubectl wait --for=condition=Ready node --all --timeout=120s
kubectl create namespace article-demo
# Pods pull the pinned public workload image from Docker Hub.
