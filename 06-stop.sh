#!/bin/bash

limactl stop worker-3 --tty=false
limactl stop worker-2 --tty=false
limactl stop worker-1 --tty=false

# limactl stop cp-3 --tty=false
# limactl stop cp-2 --tty=false
limactl stop cp-1 --tty=false
