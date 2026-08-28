```bash
cd docker
podman build --network=host -t rk3568-deb11-cross:latest .
```

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/Qt6/deb11 \
  rk3568-deb11-cross:latest \
  bash
```

```bash
podman run --rm -it \
  --network=host \
  -v /home/danial:/home/danial \
  -w /home/danial/Code/novin-med/projects/laserscanner/ \
  rk3568-deb11-cross:latest \
  bash
```
