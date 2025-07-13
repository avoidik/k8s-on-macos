#!/bin/bash

export KUBECONFIG="$HOME/.lima/cp-1/copied-from-guest/cp-1-kubeconfig.yaml"

kubectl get csr | grep -e 'Pending' -e 'system:node' | awk '{print $1}' | xargs kubectl certificate approve

kubectl scale deploy -n kube-system coredns --replicas=1

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.3.0/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml
kubectl wait --for condition=established crd gatewayclasses.gateway.networking.k8s.io --timeout=90s

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.3.0/config/crd/standard/gateway.networking.k8s.io_gateways.yaml
kubectl wait --for condition=established crd gateways.gateway.networking.k8s.io --timeout=90s

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.3.0/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml
kubectl wait --for condition=established crd httproutes.gateway.networking.k8s.io --timeout=90s

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.3.0/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml
kubectl wait --for condition=established crd referencegrants.gateway.networking.k8s.io --timeout=90s

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.3.0/config/crd/standard/gateway.networking.k8s.io_grpcroutes.yaml
kubectl wait --for condition=established crd grpcroutes.gateway.networking.k8s.io --timeout=90s

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.3.0/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml
kubectl wait --for condition=established crd tlsroutes.gateway.networking.k8s.io --timeout=90s

curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

curl -fsSLO https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/assets/cilium-values.yaml

CILIUM_CHART_VERSION='1.17.5'

helm repo add cilium https://helm.cilium.io/
helm repo update cilium
helm upgrade \
    --install cilium cilium/cilium \
    --version "$CILIUM_CHART_VERSION" \
    --namespace kube-system \
    --values cilium-values.yaml

kubectl rollout status daemonset -n kube-system cilium --timeout=90s
kubectl wait deployment -n kube-system cilium-operator --for condition=Available=True --timeout=90s

kubectl apply -f https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/assets/gateway.yaml
kubectl apply -f https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/assets/cilium-l2.yaml

METRICS_SERVER_CHART_VERSION='3.12.2'

helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update metrics-server
helm upgrade \
    --install metrics-server metrics-server/metrics-server \
    --version "$METRICS_SERVER_CHART_VERSION" \
    --set 'args={--kubelet-insecure-tls}' \
    --set 'tolerations[0].operator=Exists,tolerations[0].effect=NoSchedule' \
    --set 'replicas=1' \
    --create-namespace \
    --namespace metrics-server \
    --atomic
