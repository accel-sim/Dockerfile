# Dockerfile for Accel-Sim

This repo hosts the Dockerfiles used in regression tests for Accel-Sim and GPGPU-Sim. 
The image can be pull from Github Container Registry [accelsim cantainers](https://github.com/accel-sim/Dockerfile/pkgs/container/accel-sim-framework)
```
docker pull ghcr.io/accel-sim/accel-sim-framework:ubuntu-24.04-cuda-12.8
```

To run tests:
```
# in accel-sim-framework
docker run accelsim/development:cuda-12.8.0-ubuntu24.04 /bin/bash short-tests.sh
```
To start conianer for devlopment:

```
# in accel-sim-framework
docker run --name <container name >  --runtime=nvidia  --gpus all -it ghcr.io/accel-sim/accel-sim-framework:ubuntu-24.04-cuda-12.8 /bin/bash
```