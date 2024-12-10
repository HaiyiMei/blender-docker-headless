# Blender Docker Image

This repository contains a Dockerfile for building a Docker image for Blender.

https://hub.docker.com/r/meihaiyi/blender

## Usage

```bash
docker run -it --rm --gpus all -v $(pwd):/workspace -w /workspace meihaiyi/blender:blender-3.6-ubuntu-20.04
```

## Build

```bash
docker build -t meihaiyi/blender:blender-3.6-ubuntu-20.04 . --build-arg BLENDER_VERSION=3.6.18 --build-arg UBUNTU_VERSION=20.04
```

## Test

```bash
docker run --rm --gpus all -v $(pwd):/workspace -w /workspace meihaiyi/blender:blender-3.6-ubuntu-20.04 /workspace/tests/render_eevee.py
```

```bash
docker run --rm --gpus all -v $(pwd):/workspace -w /workspace meihaiyi/blender:blender-3.6-ubuntu-20.04 /workspace/tests/render_cycles.py
```

## GitHub Actions

The GitHub Actions workflow in [.github/workflows/docker-build-push.yml](.github/workflows/docker-build-push.yml) builds and pushes the Docker image to Docker Hub for each Blender version and Ubuntu version.

## Resources

EGL rendering:

- https://c.pgdm.ch/notes/eevee-docker-gpu
- https://archive.blender.org/developer/D6585
- https://archive.blender.org/developer/D15555
- https://projects.blender.org/blender/blender/commit/3195a381200eb98e6add8b0504f701318186946d
- https://github.com/NVIDIA/libglvnd

Nvidia container toolkit:

- https://blenderartists.org/t/belender-4-2-1-eevee-does-not-work-inside-docker/1551491/6
- https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/docker-specialized.html
- https://download.nvidia.com/XFree86/Linux-x86_64/460.56/README/installedcomponents.html

Blender images:

- https://github.com/ranchcomputing/blender-cpu-image
- https://github.com/nytimes/rd-blender-docker/tree/master
