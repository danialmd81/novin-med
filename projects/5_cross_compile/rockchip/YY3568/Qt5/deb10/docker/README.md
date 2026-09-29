#

## build docker image

```bash
cd docker
podman build --network=host -t rk3568-deb10-cross:latest .
```

## configure & build

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/Qt5/deb10 \
  rk3568-deb10-cross:latest \
  bash -c "./1_config.sh"
```

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/Qt5/deb10 \
  rk3568-deb10-cross:latest \
  bash -c "./2_build.sh && ./3_install.sh"
```

## inter-active shell

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/Qt5/deb10 \
  rk3568-deb10-cross:latest \
  bash
```

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/laserscanner/ \
  rk3568-deb10-cross:latest \
  bash
```

##

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/laserscanner/laserscanner \
  rk3568-deb10-cross:latest \
  bash -c "
    rm -rf build/cross-build-deb10-qt5 && \
    mkdir -p build/cross-build-deb10-qt5 && \
    cd build/cross-build-deb10-qt5 && \
    cmake ../.. \
      -DCMAKE_TOOLCHAIN_FILE=/home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/Qt5/deb10/toolchain.cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_TESTING=OFF \
      -DQt5_DIR=/home/danial/qt5-rk-deb10/lib/cmake/Qt5 \
      -DQT_QMAKE_EXECUTABLE=/home/danial/qt5-rk-host-tools/bin/qmake \
      -DCMAKE_PREFIX_PATH=\"/home/danial/qt5-rk-deb10;/home/danial/opencv-rk-deb10\" \
      -DOpenCV_DIR=/home/danial/opencv-rk-deb10/lib/cmake/opencv4 && \
    cmake --build . -j\$(nproc)
  "
```
