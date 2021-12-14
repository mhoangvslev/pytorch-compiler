#!/bin/bash

docker run -it --rm \
    --gpus all \
    --device /dev/nvidia0 --device /dev/nvidia-modeset \
    --device /dev/nvidia-uvm --device /dev/nvidia-uvm-tools \
    --device /dev/nvidiactl --network host \
    -v "$(realpath ./results):/content/DECA/results" \
    pytorch-compiler_pytorch-compiler;