#!/usr/bin/env bash

# Generate data for maxQ plot

#CUDA_VISIBLE_DEVICES=0
GPU_NAME='RTX3090'
TEST_DIR=$HOME/quad-gpu/maxQ

OUT_FILE=${TEST_DIR}/${GPU_NAME}_maxQ.out

# Start
# setup environment variables, etc.
export ENROOT_MOUNT_HOME=y
#export NVIDIA_DRIVER_CAPABILITIES=all

CUDA_VISIBLE_DEVICES=0,1
sudo nvidia-smi -pm 1 -i 0,1

for w in {100..350..10}
do

sudo nvidia-smi -pl $w -i 0,1
#enroot start ngc-tf1-10 python nvidia-examples/cnn/resnet.py  --layers=50  --batch_size=96  --precision=fp32 -i 120 | tee ${OUT_FILE}
enroot start ngc-tf1-10 mpiexec --allow-run-as-root --bind-to socket -np 2 python nvidia-examples/cnn/resnet.py --layers=50 -b 96 --precision=fp32 -i 180 | tee ${OUT_FILE}

ips=$(grep -E '^\s+[0-9]+\s+' ${OUT_FILE} | tr -s ' ' | cut -d ' ' -f 4 | sort -n | tail -1 ) 

echo "$w, $ips" >> ${TEST_DIR}/maxQ.data
done
exit 0
#grep -E '^\s+[0-9]+\s+' f.out | tr -s ' ' | cut -d ' ' -f 4 | sort -n | tail -1