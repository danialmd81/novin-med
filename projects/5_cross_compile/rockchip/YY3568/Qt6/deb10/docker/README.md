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
  -w /home/danial/Code/novin-med/projects/5_cross_build-deb10/rockchip/YY3568/Qt6/deb10 \
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

rm -rf laserscanner/build/cross-build-deb10/

/home/danial/qt6-rk-deb10/bin/qt-cmake -S laserscanner/ -B laserscanner/build/cross-build-deb10/ -DCMAKE_BUILD_TYPE=Release -DOpenCV_DIR=/home/danial/opencv-rk-deb10/lib/cmake/opencv4

cmake --build laserscanner/build/cross-build-deb10
```
