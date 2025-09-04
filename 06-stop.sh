#!/bin/bash

limactl stop worker-3 -y
limactl stop worker-2 -y
limactl stop worker-1 -y

# limactl stop cp-3 -y
# limactl stop cp-2 -y
limactl stop cp-1 -y
