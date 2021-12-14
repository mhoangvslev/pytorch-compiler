#!/bin/bash

echo "Do you want to compile using RoCm? (0/1)"
read USE_ROCM

export USE_ROCM=$USE_ROCM
export CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which conda))/../"}
python setup.py build --cmake-only
ccmake build  # or cmake-gui build