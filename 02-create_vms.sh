#!/bin/bash

limactl create template://k8s-macos-cp-1 --name cp-1 --tty=false
# limactl create template://k8s-macos-cp-2 --name cp-2 --tty=false
# limactl create template://k8s-macos-cp-3 --name cp-3 --tty=false

limactl create template://k8s-macos-worker-1 --name worker-1 --tty=false
limactl create template://k8s-macos-worker-2 --name worker-2 --tty=false
limactl create template://k8s-macos-worker-3 --name worker-3 --tty=false
