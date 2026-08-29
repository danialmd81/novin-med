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
