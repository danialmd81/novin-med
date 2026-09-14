#

## build docker image

```bash
cd docker
podman build --network=host -t rk3568-deb11-cross:latest .
```

## configure & build

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/Qt6/deb11 \
  rk3568-deb11-cross:latest \
  bash -c "./1_config.sh && ./2_build.sh"
```

## inter-active shell

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/laserscanner/ \
  rk3568-deb11-cross:latest \
  bash
```

##

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/laserscanner/ \
  rk3568-deb11-cross:latest \
  bash

rm -rf laserscanner/build/cross-build-deb11/

/home/danial/qt6-rk-deb11/bin/qt-cmake -S laserscanner/ -B laserscanner/build/cross-build-deb11/ -DOpenCV_DIR=/home/danial/opencv-rk-deb11/lib/cmake/opencv4

cmake --build laserscanner/build/cross-build-deb11
```
