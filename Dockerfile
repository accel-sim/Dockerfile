# ===========================
# Base Stage: Install System Dependencies
# ===========================
FROM nvidia/cuda:12.8.0-cudnn-devel-ubuntu24.04 AS base

SHELL ["/bin/bash", "-c"]
WORKDIR /accel-sim

# Set up environment variables
ENV CUDA_INSTALL_PATH=/usr/local/cuda \
    PTXAS_CUDA_INSTALL_PATH=/usr/local/cuda \
    BOOST_ROOT=/usr/include/boost \
    PATH=/usr/local/cuda/bin:$PATH \
    GPUAPPS_ROOT=/accel-sim/gpu-app-collection

# Install essential dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget build-essential xutils-dev bison zlib1g-dev flex \
    libglu1-mesa-dev git g++ libssl-dev libxml2-dev libboost-all-dev \
    vim python3-setuptools python3-pip python3-venv cmake \
    libfreeimage3 libfreeimage-dev freeglut3-dev pkg-config \
    python3-doc python3-tk python3.12-venv python3.12-doc \
    binfmt-support psmisc apt-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ===========================
# Python Stage: Setup Virtual Environment
# ===========================
FROM base AS python-env

# Create and activate a virtual environment (PEP 668 compliant)
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Upgrade pip and install required Python packages
RUN pip install --upgrade pip && \
    pip install pyyaml plotly psutil

# ===========================
# App Stage: Clone and Build Accel-Sim GPU App Collection
# ===========================
FROM python-env AS app

# Clone the repository and build
RUN git clone --recurse-submodules https://github.com/accel-sim/gpu-app-collection.git && \
    cd gpu-app-collection && \
    bash test-build.sh && \
    bash get_regression_data.sh

# ===========================
# Nsight Compute Stage: Install Nsight CLI
# ===========================
FROM python-env AS nsight

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Add NVIDIA repository and install Nsight CLI
RUN apt-get update --allow-insecure-repositories && \
    apt-get install -y --no-install-recommends gnupg wget && \
    mkdir -p /etc/apt/keyrings && \
    wget -qO - https://developer.download.nvidia.com/devtools/repos/ubuntu2404/amd64/7fa2af80.pub | tee /etc/apt/keyrings/nvidia.asc && \
    echo "deb [signed-by=/etc/apt/keyrings/nvidia.asc] http://developer.download.nvidia.com/devtools/repos/ubuntu2404/amd64 /" | tee /etc/apt/sources.list.d/nvidia.list && \
    apt-get update --allow-insecure-repositories && \
    apt-get install -y nsight-systems-cli --allow-unauthenticated && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ===========================
# Final Stage: Define Entry Point
# ===========================
CMD ["/bin/bash"]
