
#============================
# Main
#============================

# Check Python version
PYTHON_VER="None"
until [ $(conda search python | awk '{if (NR > 2) {print $2} }' | uniq | grep -x ${PYTHON_VER}) ]
do
    echo "Python version ?"
    read PYTHON_VER
done

# Check CUDA
CUDA_VER="None"
until $(wget -q https://registry.hub.docker.com/v1/repositories/nvidia/cuda/tags -O - \
    | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' \
    | tr '}' '\n' \
    | awk -F: '{print $3}' \
    | grep -q "$CUDA_VER-")
do
    echo "CUDA version?"
    read CUDA_VER
done

# Check CUDA
PYTORCH_VER="None"
until $(wget -q 'https://api.github.com/repos/pytorch/pytorch/tags?page=1&per_page=1000' -O - \
    | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' \
    | tr '}' '\n' \
    | grep -Po 'v(\d+\.){2}\d+(-rc\d+)?' \
    | sort | uniq | grep -xq "$PYTORCH_VER")
do
    echo "PyTorch version?"
    read PYTORCH_VER
done

if [ $(echo $CUDA_VER | egrep -o '^[0-9]+') -gt 10 ]; then
    CUDA_DOCKER_TAG="$CUDA_VER-devel-ubuntu18.04"
else
    CUDA_DOCKER_TAG="$CUDA_VER-devel-ubuntu16.04"
fi

# Summary
echo "#!/usr/bin/env bash" > .env
echo "PYTHON_VER=$PYTHON_VER" >> .env
echo "CUDA_VER=$CUDA_VER" >> .env
echo "CUDA_DOCKER_TAG=$CUDA_DOCKER_TAG" >> .env
echo "PYTORCH_VER=$PYTORCH_VER" >> .env