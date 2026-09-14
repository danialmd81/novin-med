FROM docker.io/library/debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        ninja-build \
        gcc-aarch64-linux-gnu \
        g++-aarch64-linux-gnu \
        pkg-config \
        libglib2.0-0 \
        libdbus-1-3 \
        libgl1 \
        libegl1 \
        libfontconfig1 \
        libfreetype6 \
        libx11-6 \
        libx11-xcb1 \
        libxkbcommon0 \
        libxkbcommon-x11-0 \
        perl \
        python3 \
        git \
        rsync \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace