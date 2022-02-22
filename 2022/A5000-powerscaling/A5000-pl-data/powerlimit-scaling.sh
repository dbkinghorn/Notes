#!/usr/bin/env bash

# Generate data for power scaling plot

#CUDA_VISIBLE_DEVICES=0
GPU_NAME='A5000'
TEST_DIR=$PWD

OUT_FILE=${TEST_DIR}/${GPU_NAME}_maxQ.out

# Start
# setup environment variables, etc.
export ENROOT_MOUNT_HOME=y
#export NVIDIA_DRIVER_CAPABILITIES=all

CUDA_VISIBLE_DEVICES=0,1,2,3
#sudo nvidia-smi -pm 1 -i 0,1,2

for w in {130..230..10}
do

sudo nvidia-smi -pl $w #-i 0,1,2
#enroot start ngc-tf1-10 python nvidia-examples/cnn/resnet.py  --layers=50  --batch_size=96  --precision=fp32 -i 120 | tee ${OUT_FILE}
enroot start tf1-ngc mpiexec --allow-run-as-root -np 4 python nvidia-examples/cnn/resnet.py --layers=50 -b 96 --precision=fp32 -i 180 | tee ${OUT_FILE}

ips=$(grep -E '^\s+[0-9]+\s+' ${OUT_FILE} | tr -s ' ' | cut -d ' ' -f 4 | sort -n | tail -1 ) 

echo "$w, $ips" >> ${TEST_DIR}/maxQ.data
done
exit 0
#grep -E '^\s+[0-9]+\s+' f.out | tr -s ' ' | cut -d ' ' -f 4 | sort -n | tail -1