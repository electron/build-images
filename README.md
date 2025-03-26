# Electron Build Images

> Docker containers used to build Electron on Linux

[![Actions Status](https://github.com/electron/build-images/workflows/Build%20and%20Publish%20Docker%20images/badge.svg)](https://github.com/electron/build-images/actions)

## Published Images

All images are published to the GitHub Container Registry.

Specific versions of the build image are available under a docker tag equivalent to a git commit SHA. E.g.

```bash
docker pull ghcr.io/electron/build:3d8d44d0f15b05bef6149e448f9cc522111847e9
```

### Linux x64

```bash
docker pull ghcr.io/electron/build:latest
```

### Linux Arm

This image is used for testing 32 bit Arm builds

```bash
docker pull ghcr.io/electron/test:arm32v7-latest
```

### Linux Arm64

This image is used for testing 64 bit Arm builds

```bash
docker pull ghcr.io/electron/test:arm64v8-latest
```

### Linux Devcontainer

This image is used for Electron Codespaces environments or other isolated docker-backed developer environments.  It contains additional dependencies like a VNC server that can make testing Electron easier.

```bash
docker pull ghcr.io/electron/devcontainer:latest
```
