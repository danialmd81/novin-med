#!/usr/bin/env bash
set -e

# Target device IP (Raspberry Pi 4)
TARGET_IP="192.168.1.134"
SYSROOT_DIR="${HOME}/rpi4-deb10-sysroot"

mkdir -p "${SYSROOT_DIR}"

echo "Starting sysroot sync from ${TARGET_IP}..."

# 1. Sync /lib
rsync -avzP --partial --safe-links \
  -e 'ssh -o ServerAliveInterval=15 -o ServerAliveCountMax=6' \
  "root@${TARGET_IP}:/lib" \
  "${SYSROOT_DIR}/"

# 2. Sync /usr/lib and /usr/include
rsync -avzP --partial --safe-links \
  -e 'ssh -o ServerAliveInterval=15 -o ServerAliveCountMax=6' \
  --exclude='/usr/share/doc' \
  --exclude='/usr/share/man' \
  --exclude='/usr/share/locale' \
  --exclude='/usr/share/icons' \
  --exclude='/usr/share/fonts' \
  --exclude='/usr/lib/chromium-browser' \
  --exclude='/usr/lib/aspell' \
  --exclude='/usr/lib/jvm' \
  --exclude='/usr/lib/firefox*' \
  "root@${TARGET_IP}:/usr/lib" \
  "root@${TARGET_IP}:/usr/include" \
  "${SYSROOT_DIR}/usr/"

# 3. Sync pkgconfig from /usr/share (if present)
rsync -avzP --partial --safe-links \
  -e 'ssh -o ServerAliveInterval=15 -o ServerAliveCountMax=6' \
  "root@${TARGET_IP}:/usr/share/pkgconfig" \
  "${SYSROOT_DIR}/usr/share/" || true

echo "Sysroot sync complete."