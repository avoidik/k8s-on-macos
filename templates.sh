#!/bin/bash

mkdir ~/.lima/_templates

curl -fsSL https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/k8s-macos-cp-1.yaml \
    -o ~/.lima/_templates/k8s-macos-cp-1.yaml
curl -fsSL https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/k8s-macos-cp-2.yaml \
    -o ~/.lima/_templates/k8s-macos-cp-2.yaml
curl -fsSL https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/k8s-macos-cp-3.yaml \
    -o ~/.lima/_templates/k8s-macos-cp-3.yaml

curl -fsSL https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/k8s-macos-worker-1.yaml \
    -o ~/.lima/_templates/k8s-macos-worker-1.yaml
curl -fsSL https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/k8s-macos-worker-2.yaml \
    -o ~/.lima/_templates/k8s-macos-worker-2.yaml
curl -fsSL https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/k8s-macos-worker-3.yaml \
    -o ~/.lima/_templates/k8s-macos-worker-3.yaml
