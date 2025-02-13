# Dockerfile for Accel-Sim

This repo hosts the Dockerfiles used in regression tests for Accel-Sim and GPGPU-Sim. 
The image can be pull from Docker Hub [accelsim/development](https://hub.docker.com/repository/docker/accelsim/development/general)
```
docker pull accelsim/development:cuda-12.8.0-ubuntu24.04 
```

To run tests:
```
# in accel-sim-framework
docker run accelsim/development:cuda-12.8.0-ubuntu24.04 /bin/bash short-tests.sh
```
