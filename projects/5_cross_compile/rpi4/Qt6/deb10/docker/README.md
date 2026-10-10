#

## build docker image

```bash
podman build --network=host -t rpi4-deb10-cross:latest .
```

## Configure & build Qt6

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/5_cross_compile/rpi4/Qt6/deb10 \
  rpi4-deb10-cross:latest \
  bash -c "./1_config.sh"
```

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/5_cross_compile/rpi4/Qt6/deb10 \
  rpi4-deb10-cross:latest \
  bash -c "./2_build.sh && ./3_install.sh"
```

## Build CMake application

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects \
  rpi4-deb10-cross:latest \
  bash -c "
    rm -rf build/cross-build-deb10-qt6 && \
    mkdir -p build/cross-build-deb10-qt6 && \
    cd build/cross-build-deb10-qt6 && \
    cmake ../.. \
      -DCMAKE_TOOLCHAIN_FILE=/home/danial/Code/novin-med/projects/5_cross_compile/rpi4/Qt6/deb10/toolchain.cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_TESTING=OFF \
      -DQt6_DIR=/home/danial/qt6-rpi4-deb10/lib/cmake/Qt6 \
      -DQT_QMAKE_EXECUTABLE=/home/danial/qt6-rpi4-host-tools/bin/qmake \
      -DCMAKE_PREFIX_PATH=\"/home/danial/qt6-rpi4-deb10" \
    cmake --build . -j\$(nproc)
  "
```
