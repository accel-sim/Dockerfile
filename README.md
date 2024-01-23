# Dockerfile for Accel-Sim

This repo hosts the Dockerfiles used in regression tests for Accel-Sim and GPGPU-Sim. 
The image can be pull from Docker Hub [tgrogers/accel-sim_regress](https://hub.docker.com/r/tgrogers/accel-sim_regress)
```
docker pull tgrogers/accel-sim_regress:Ubuntu-22.04-cuda-11.7
```

To run tests:
```
# in accel-sim-framework
docker run tgrogers/accel-sim_regress:Ubuntu-22.04-cuda-11.7 /bin/bash short-tests.sh
```