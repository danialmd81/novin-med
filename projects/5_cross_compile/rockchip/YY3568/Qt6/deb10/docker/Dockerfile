FROM docker.io/library/debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

# Point APT to archive mirrors and disable expiration checks
RUN echo "deb http://archive.debian.org/debian buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
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
        curl \
        ca-certificates \
        tar \
    && rm -rf /var/lib/apt/lists/*

# Install official CMake 3.26+ binary
RUN curl -fsSL https://github.com/Kitware/CMake/releases/download/v3.26.5/cmake-3.26.5-linux-x86_64.tar.gz | \
    tar --strip-components=1 -xz -C /usr/local

RUN ln -sf /usr/bin/make /usr/bin/gmake

WORKDIR /workspace