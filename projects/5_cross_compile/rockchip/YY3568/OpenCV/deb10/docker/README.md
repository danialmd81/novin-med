#

## build docker image

```bash
cd docker
podman build --network=host -t rk3568-deb10-cross:latest .
```

## configure

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/OpenCV/deb10 \
  rk3568-deb10-cross:latest \
  bash -c "./1_config.sh"
```

## build

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/OpenCV/deb10 \
  rk3568-deb10-cross:latest \
  bash -c "./2_build.sh"
```

## install

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/OpenCV/deb10 \
  rk3568-deb10-cross:latest \
  bash -c "./3_install.sh"
```

## inter-active shell

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/OpenCV/deb10 \
  rk3568-deb10-cross:latest \
  bash
```
