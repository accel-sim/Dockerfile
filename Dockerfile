FROM ubuntu:18.04

SHELL ["/bin/bash", "-c"]

WORKDIR /accel-sim
ADD . /accel-sim

ENV CUDA_INSTALL_PATH /usr/local/cuda-11.0
ENV PTXAS_CUDA_INSTALL_PATH /usr/local/cuda-11.0
ENV GPUAPPS_ROOT /accel-sim/gpu-app-collection

RUN apt-get update \
&& apt-get install -y wget build-essential xutils-dev bison zlib1g-dev flex \
      libglu1-mesa-dev git g++ libssl-dev libxml2-dev libboost-all-dev git g++ \
      libxml2-dev vim python-setuptools python3-pip cmake \
&& apt-get clean \
&& pip3 install pyyaml plotly psutil \
&& wget http://developer.download.nvidia.com/compute/cuda/11.0.2/local_installers/cuda_11.0.2_450.51.05_linux.run \
&& sh cuda_11.0.2_450.51.05_linux.run --silent --toolkit \
&& rm cuda_11.0.2_450.51.05_linux.run \
&& rm -rf /usr/local/cuda-11.0/nsight-compute-2020.1.2 

RUN export PATH=$CUDA_INSTALL_PATH/bin:$PATH \
&& git clone https://github.com/accel-sim/gpu-app-collection \
&& source ./gpu-app-collection/src/setup_environment \
&& make -j -C ./gpu-app-collection/src rodinia_2.0-ft \
&& make -j -C ./gpu-app-collection/src GPU_Microbenchmark \
&& make -j -C ./gpu-app-collection/src data \
&& rm gpucomputingsdk_4.2.9_linux.run \
&& rm -rf 4.2
