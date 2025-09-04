#!/bin/bash

limactl delete worker-3 -y -f
limactl delete worker-2 -y -f
limactl delete worker-1 -y -f

# limactl delete cp-3 -y -f
# limactl delete cp-2 -y -f
limactl delete cp-1 -y -f
