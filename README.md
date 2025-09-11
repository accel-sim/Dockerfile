# Dockerfile for Accel-Sim

This repository hosts the Dockerfiles used in regression tests for **Accel-Sim** and **GPGPU-Sim**.  
Prebuilt images are available on the GitHub Container Registry: [accel-sim containers](https://github.com/accel-sim/Dockerfile/pkgs/container/accel-sim-framework)

## Requirements
To enable GPU access inside Docker containers, you need to install the **NVIDIA Container Toolkit**.  
Follow the installation guide here: [NVIDIA Container Toolkit Install Guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

---

## Pull the image
```bash
docker pull ghcr.io/accel-sim/accel-sim-framework:ubuntu-24.04-cuda-12.8
```

## Run regression tests
From inside `accel-sim-framework`:
```bash
docker run ghcr.io/accel-sim/accel-sim-framework:ubuntu-24.04-cuda-12.8 /bin/bash short-tests.sh
```

## Start a container for development
```bash
docker run --name <container_name> --runtime=nvidia --gpus all -it \
  ghcr.io/accel-sim/accel-sim-framework:ubuntu-24.04-cuda-12.8 /bin/bash
```

## Build the image locally
If you want to modify the Dockerfile and build your own image:
```bash
# from the directory containing the Dockerfile
docker build -t accelsim/dev:local .
```


---

## Notes
- Replace `<container_name>` with a descriptive name for your container.  
- The `--runtime=nvidia --gpus all` flags ensure GPU access inside the container (requires NVIDIA Container Toolkit).  
- Use the local tag `accelsim/dev:local` when running your custom build.  

