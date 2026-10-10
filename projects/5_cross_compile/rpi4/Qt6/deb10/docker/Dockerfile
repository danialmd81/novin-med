FROM docker.io/library/debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

# 1. Enable 32-bit ARM (armhf) architecture
RUN dpkg --add-architecture armhf

# 2. Point APT to archive mirrors and disable expiration checks for Buster
RUN echo "deb http://archive.debian.org/debian buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ninja-build \
        pkg-config \
        perl \
        python3 \
        git \
        rsync \
        curl \
        ca-certificates \
        tar \
        symlinks \
        # 32-bit ARM Cross-Compiler Toolchain (RPi4 32-bit Buster target)
        gcc-arm-linux-gnueabihf \
        g++-arm-linux-gnueabihf \
        # Host x86_64 runtimes (Required for Qt6 host tools: qsb, qdbusxml2cpp, moc)
        libdbus-1-3 \
        libglib2.0-0 \
        libxkbcommon0 \
        libxkbcommon-x11-0 \
        libgl1 \
        libegl1 \
        libfontconfig1 \
        libfreetype6 \
        libx11-6 \
        libx11-xcb1 \
        # Target ARMHF libraries (Provides sysroot fallback headers & pkg-config entries)
        libgl1-mesa-dev:armhf \
        libegl1-mesa-dev:armhf \
        libgles2-mesa-dev:armhf \
        libgbm-dev:armhf \
        libdrm-dev:armhf \
        libfontconfig1-dev:armhf \
        libfreetype6-dev:armhf \
        libx11-dev:armhf \
        libx11-xcb-dev:armhf \
        libxkbcommon-dev:armhf \
        libxkbcommon-x11-dev:armhf \
        libdbus-1-dev:armhf \
        libglib2.0-dev:armhf \
    && rm -rf /var/lib/apt/lists/*

# 3. Install official CMake binary (Qt6 configure requires CMake >= 3.16)
RUN curl -fsSL -k https://github.com/Kitware/CMake/releases/download/v3.26.5/cmake-3.26.5-linux-x86_64.tar.gz | \
    tar --strip-components=1 -xz -C /usr/local

RUN ln -sf /usr/bin/make /usr/bin/gmake

WORKDIR /workspace