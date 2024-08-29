FROM tgrogers/accel-sim_regress:Ubuntu-22.04-cuda-11.7

SHELL ["/bin/bash", "-c"]

WORKDIR /accel-sim
ADD . /accel-sim

ENV CUDA_INSTALL_PATH /usr/local/cuda-11.7
ENV PTXAS_CUDA_INSTALL_PATH /usr/local/cuda-11.7
ENV GPUAPPS_ROOT /accel-sim/gpu-app-collection
ENV LLVM_INSTALL_PATH /accel-sim/llvm-install
ENV RISCV_TOOLCHAIN_INSTALL_PATH /accel-sim/riscv-gnu-install

# Build LLVM 18.1.8
RUN git clone https://github.com/llvm/llvm-project.git \
&& mkdir llvm-install \
&& cd llvm-project \
&& git checkout llvmorg-18.1.8 \
&& mkdir build && cd build \
&& cmake -DLLVM_TARGETS_TO_BUILD="RISCV;X86;NVPTX" -DLLVM_DEFAULT_TARGET_TRIPLE=riscv64-unknown-linux-gnu \
         -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang;lld" -DCMAKE_INSTALL_PREFIX=$LLVM_INSTALL_PATH ../llvm \
&& cmake --build . -j4 \
&& cmake --build . --target install \
&& cd .. && cd .. \
&& rm -rf llvm-project

# Build RISCV GNU Toolchain 2024.08.06.nightly
RUN apt-get update && apt-get -y install autoconf automake autotools-dev curl python3 python3-pip libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev libslirp-dev
RUN git clone https://github.com/riscv-collab/riscv-gnu-toolchain.git \
&& mkdir riscv-gnu-install \
&& cd riscv-gnu-toolchain \
&& git checkout 2024.08.06 \
&& ./configure --prefix=$RISCV_TOOLCHAIN_INSTALL_PATH \
&& make linux -j4 \
&& cd .. \
&& rm -rf riscv-gnu-toolchain

# Setup GPU app collection in SST mode
# Also remove prebuilt x86 binaries
# Also remove all data except for rodinia-2.0
RUN export PATH=$CUDA_INSTALL_PATH/bin:$PATH \
&& cd gpu-app-collection \
&& git pull \
&& git checkout sst_support \ 
&& source ./src/setup_environment sst \
&& rm gpucomputingsdk_4.2.9_linux.run \
&& rm -rf 4.2 \
&& rm -rf ./bin \
&& mv ./data_dirs/cuda/rodinia/2.0-ft . \
&& rm -rf ./data_dirs \
&& mkdir -p ./data_dirs/cuda/rodinia/ \
&& mv ./2.0-ft ./data_dirs/cuda/rodinia/ \
&& ls ./data_dirs/cuda/rodinia/ \
&& cd ..
