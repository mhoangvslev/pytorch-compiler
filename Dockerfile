ARG CUDA_DOCKER_TAG
FROM nvidia/cuda:${CUDA_DOCKER_TAG}

ARG PYTHON_VER
ENV PYTHON_VER=${PYTHON_VER}

RUN apt-get update \
    && apt-get install -y wget curl git

# Miniconda
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

RUN conda create -n xp
SHELL ["conda", "run", "--no-capture-output", "-n", "xp", "/bin/bash", "-c"]
RUN conda install python=${PYTHON_VER} astunparse numpy ninja pyyaml mkl mkl-include setuptools cmake cffi typing_extensions future six requests dataclasses
RUN conda install -c pytorch magma-cuda110 
RUN conda init bash && echo "conda activate xp" >> ~/.bashrc

# Get PyTorch source
ARG PYTORCH_VER
ENV PYTORCH_VER=${PYTORCH_VER}
RUN git clone --progress --recursive https://github.com/pytorch/pytorch --branch ${PYTORCH_VER}

WORKDIR /pytorch
COPY build.sh .

