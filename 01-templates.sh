#!/bin/bash

mkdir -p ~/.lima/_templates

cri_type="${2:-}"
dir_suffix="templates${cri_type:+-$cri_type}"

if [[ "$1" == "download" ]]; then

    curl -fsSL https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/${dir_suffix}/k8s-macos-cp-1.yaml \
        -o ~/.lima/_templates/k8s-macos-cp-1.yaml
    curl -fsSL https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/${dir_suffix}/k8s-macos-cp-2.yaml \
        -o ~/.lima/_templates/k8s-macos-cp-2.yaml
    curl -fsSL https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/${dir_suffix}/k8s-macos-cp-3.yaml \
        -o ~/.lima/_templates/k8s-macos-cp-3.yaml

    curl -fsSL https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/${dir_suffix}/k8s-macos-worker-1.yaml \
        -o ~/.lima/_templates/k8s-macos-worker-1.yaml
    curl -fsSL https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/${dir_suffix}/k8s-macos-worker-2.yaml \
        -o ~/.lima/_templates/k8s-macos-worker-2.yaml
    curl -fsSL https://raw.githubusercontent.com/avoidik/k8s-on-macos/refs/heads/main/${dir_suffix}/k8s-macos-worker-3.yaml \
        -o ~/.lima/_templates/k8s-macos-worker-3.yaml

elif [[ "$1" == "copy" ]]; then

    cp ${dir_suffix}/k8s-macos-cp-1.yaml ~/.lima/_templates/k8s-macos-cp-1.yaml
    cp ${dir_suffix}/k8s-macos-cp-2.yaml ~/.lima/_templates/k8s-macos-cp-2.yaml
    cp ${dir_suffix}/k8s-macos-cp-3.yaml ~/.lima/_templates/k8s-macos-cp-3.yaml

    cp ${dir_suffix}/k8s-macos-worker-1.yaml ~/.lima/_templates/k8s-macos-worker-1.yaml
    cp ${dir_suffix}/k8s-macos-worker-2.yaml ~/.lima/_templates/k8s-macos-worker-2.yaml
    cp ${dir_suffix}/k8s-macos-worker-3.yaml ~/.lima/_templates/k8s-macos-worker-3.yaml

else

    echo "usage: $0 [download|copy] [docker]"

fi
