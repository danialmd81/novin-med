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
  -w /home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/Qt6/deb10 \
  rk3568-deb10-cross:latest \
  bash -c "./1_config.sh && ./2_build.sh"
```

## inter-active shell

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
  -w /home/danial/Code/novin-med/projects/laserscanner/ \
  rk3568-deb10-cross:latest \
  bash

cmake -D CMAKE_TOOLCHAIN_FILE=/home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/OpenCV/deb10/opencv-rk-toolchain.cmake \
      -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=/usr/local/opencv-rk \
      -D WITH_TBB=OFF \
      -D WITH_V4L=ON \
      -D WITH_QT=OFF \
      -D WITH_OPENGL=OFF \
      -D WITH_GSTREAMER=ON \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_opencv_python2=OFF \
      -D BUILD_opencv_python3=OFF \
      -D ENABLE_NEON=ON \
      -D CPU_BASELINE=NEON \
      -D ENABLE_FAST_MATH=1 \
      -D OPENCV_ENABLE_NONFREE=ON \
      ..

make -j$(nproc)

```
