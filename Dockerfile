FROM tgrogers/accel-sim_regress:Ubuntu-22.04-cuda-11.7

SHELL ["/bin/bash", "-c"]

WORKDIR /accel-sim
ADD . /accel-sim

ENV CUDA_INSTALL_PATH /usr/local/cuda-11.7
ENV PTXAS_CUDA_INSTALL_PATH /usr/local/cuda-11.7
ENV GPUAPPS_ROOT /accel-sim/gpu-app-collection

# Build LLVM 18.1.8
# RUN git clone https://github.com/llvm/llvm-project.git \
# && mkdir llvm-install \
# && export LLVM_INSTALL_PATH=$(pwd)/llvm-install \
# && cd llvm-project \
# && git checkout llvmorg-18.1.8 \
# && mkdir build && cd build \
# && cmake -DLLVM_TARGETS_TO_BUILD="RISCV;X86;NVPTX" -DLLVM_DEFAULT_TARGET_TRIPLE=riscv64-unknown-linux-gnu \
#          -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang;lld" -DCMAKE_INSTALL_PREFIX=$LLVM_INSTALL_PATH ../llvm \
# && cmake --build . -j4 \
# && cmake --build . --target install \
# && cd .. && cd ..

# Build RISCV GNU Toolchain 2024.08.06.nightly
RUN apt-get update && apt-get -y install autoconf automake autotools-dev curl python3 python3-pip libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev libslirp-dev
RUN git clone https://github.com/riscv-collab/riscv-gnu-toolchain.git \
&& mkdir riscv-gnu-install \
&& export RISCV_TOOLCHAIN_INSTALL_PATH=$(pwd)/riscv-gnu-install \
&& cd riscv-gnu-toolchain \
&& git checkout 2024.08.06 \
&& ./configure --prefix=$RISCV_INSTALL_PATH \
&& make linux -j4 \
&& cd ..

# Setup GPU app collection
RUN export PATH=$CUDA_INSTALL_PATH/bin:$PATH \
&& git clone https://github.com/accel-sim/gpu-app-collection \
&& cd gpu-app-collection \
&& git checkout sst_support \ 
&& source ./src/setup_environment sst \
&& rm gpucomputingsdk_4.2.9_linux.run \
&& rm -rf 4.2 \
&& cd ..
