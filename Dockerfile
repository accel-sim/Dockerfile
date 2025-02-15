FROM nvidia/cuda:12.8.0-cudnn-devel-ubuntu24.04

SHELL ["/bin/bash", "-c"]

WORKDIR /accel-sim
ADD . /accel-sim

ENV CUDA_INSTALL_PATH=/usr/local/cuda
ENV PTXAS_CUDA_INSTALL_PATH=/usr/local/cuda
#ENV GPUAPPS_ROOT /accel-sim/gpu-app-collection

RUN apt-get update
RUN apt-get install -y wget build-essential xutils-dev bison zlib1g-dev flex \
      libglu1-mesa-dev git g++ libssl-dev libxml2-dev libboost-all-dev git g++ \
      libxml2-dev vim python3-setuptools python3-pip python3-venv cmake \
      libfreeimage3 libfreeimage-dev \
      python3-doc python3-tk python3.12-venv python3.12-doc binfmt-support psmisc apt-utils
RUN apt-get clean 

# Create and activate a virtual environment, venv is needed because of PEP 668
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"
RUN pip3 install --upgrade pip
RUN pip3 install pyyaml plotly psutil

