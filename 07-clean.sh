#!/bin/bash

limactl delete worker-3 --tty=false --force
limactl delete worker-2 --tty=false --force
limactl delete worker-1 --tty=false --force

# limactl delete cp-3 --tty=false --force
# limactl delete cp-2 --tty=false --force
limactl delete cp-1 --tty=false --force
