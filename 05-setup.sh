#!/bin/bash

export KUBECONFIG="$HOME/.lima/cp-1/copied-from-guest/cp-1-kubeconfig.yaml"

kubectl get csr | grep 'system:node' | grep 'Pending' | awk '{print $1}' | xargs kubectl certificate approve

kubectl scale deploy -n kube-system coredns --replicas=1

GATEWAY_API_VER='v1.3.0'

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${GATEWAY_API_VER}/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml
kubectl wait --for condition=established crd gatewayclasses.gateway.networking.k8s.io --timeout=90s

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${GATEWAY_API_VER}/config/crd/standard/gateway.networking.k8s.io_gateways.yaml
kubectl wait --for condition=established crd gateways.gateway.networking.k8s.io --timeout=90s

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${GATEWAY_API_VER}/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml
kubectl wait --for condition=established crd httproutes.gateway.networking.k8s.io --timeout=90s

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${GATEWAY_API_VER}/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml
kubectl wait --for condition=established crd referencegrants.gateway.networking.k8s.io --timeout=90s

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${GATEWAY_API_VER}/config/crd/standard/gateway.networking.k8s.io_grpcroutes.yaml
kubectl wait --for condition=established crd grpcroutes.gateway.networking.k8s.io --timeout=90s

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${GATEWAY_API_VER}/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml
kubectl wait --for condition=established crd tlsroutes.gateway.networking.k8s.io --timeout=90s

CILIUM_CHART_VERSION='1.18.1'

helm repo add cilium https://helm.cilium.io/ --force-update
helm repo update cilium
helm upgrade \
    --install cilium cilium/cilium \
    --version "$CILIUM_CHART_VERSION" \
    --namespace kube-system \
    --values assets/cilium-values.yaml \
    --atomic

kubectl rollout status daemonset -n kube-system cilium --timeout=90s
kubectl wait deployment -n kube-system cilium-operator --for condition=Available=True --timeout=90s

kubectl apply -f assets/gateway.yaml
kubectl apply -f assets/cilium-l2.yaml

kubectl get configmaps -n kube-system kubeadm-config -o yaml | yq '.data.ClusterConfiguration | from_yaml | .networking.podSubnet'

kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.podCIDR}{"\n"}' | column -ts $'\t'

METRICS_SERVER_CHART_VERSION='3.12.2'

helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/ --force-update
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

kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.32/deploy/local-path-storage.yaml
kubectl apply -f assets/local-path-cm.yaml

cilium status --wait
