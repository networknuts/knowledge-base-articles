#!/usr/bin/env bash
set -euo pipefail
export KUBECONFIG="$PWD/lab-kubeconfig"
test "$(kubectl config current-context)" = kind-nn-blog-lab
kubectl -n article-demo create configmap app-settings --from-literal=mode=blue
kubectl apply -f pod.yaml
kubectl -n article-demo wait --for=condition=Ready pod/config-reader --timeout=90s
kubectl -n article-demo exec config-reader -- printenv APP_MODE | tee before.txt
test "$(cat before.txt)" = blue
kubectl -n article-demo patch configmap app-settings --type merge -p '{"data":{"mode":"green"}}'
kubectl -n article-demo get configmap app-settings -o jsonpath='{.data.mode}'
printf '
'
test "$(kubectl -n article-demo get configmap app-settings -o jsonpath='{.data.mode}')" = green
kubectl -n article-demo exec config-reader -- printenv APP_MODE | tee unchanged.txt
test "$(cat unchanged.txt)" = blue
kubectl -n article-demo delete pod config-reader --wait=true
kubectl apply -f pod.yaml
kubectl -n article-demo wait --for=condition=Ready pod/config-reader --timeout=90s
kubectl -n article-demo exec config-reader -- printenv APP_MODE | tee after.txt
test "$(cat after.txt)" = green
{
 printf 'Before ConfigMap edit: '; cat before.txt
 printf 'Existing Pod after ConfigMap edit: '; cat unchanged.txt
 printf 'Recreated Pod: '; cat after.txt
} | tee details.txt
printf 'PASS: ConfigMap changed, existing environment stayed blue, recreated Pod received green.
'
