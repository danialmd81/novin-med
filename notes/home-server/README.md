
# Home Server for AI Video Generation (and more)

This guide helps you build a home server that can run AI workloads (especially video generation) and other self-hosted services, and lets you access them safely from the internet.

It’s written for learning-by-doing. You can start small (CPU-only + remote access) and then add a GPU and heavier workloads.

---

## 📘 Topic Overview

A **home server** is a computer you run 24/7 (or on-demand) in your home network to provide services like:

* AI inference (text/image/video generation)
* file storage (NAS)
* media streaming
* development tools (Git, CI, databases)
* remote desktop and “personal cloud” apps

For **AI video generation**, the main pain points are:

* GPU requirements (VRAM matters a lot)
* stable drivers + CUDA stack
* storage and network bandwidth
* secure access—exposing services directly is risky

In real projects/teams, you commonly see the same pattern:

1. Linux server + Docker
2. GPU passthrough to containers
3. Internal services behind a reverse proxy
4. Remote access via VPN (recommended) or reverse proxy with HTTPS

---

## 🧠 Core Concepts (What You Must Know)

### Hardware basics (what matters for AI)

* **GPU (NVIDIA)**: Most AI video generation frameworks expect CUDA. VRAM is usually the limiting factor.
  * Practical starting point: **12GB VRAM+** (usable), better: **16–24GB+**.
* **CPU**: important for preprocessing, decompression, background tasks; not the main limiter.
* **RAM**: 32GB is comfortable; 64GB helps if you run many services.
* **Storage**:
  * NVMe SSD for models + working directories (speed)
  * HDD/SSD for archives and output videos (capacity)

### Hardware shopping checklist (practical parts)

This is a “parts list” you can use like a checklist when building.

#### GPU (the most important part)

* Prefer **NVIDIA** for broad compatibility (CUDA).
* VRAM guidance (very rough, but useful):
  * **12GB**: entry level for many workflows
  * **16GB**: comfortable starting point
  * **24GB+**: much easier for higher-res / longer clips / heavier pipelines
* Pay attention to:
  * **power connectors** (8-pin / 12VHPWR) and PSU support
  * **physical size** (length and thickness) and case clearance
  * cooling/noise (home servers often run for hours)

Example part names:

* NVIDIA GeForce RTX 3060 12GB
* NVIDIA GeForce RTX 4070 Ti SUPER 16GB
* NVIDIA GeForce RTX 3090 24GB

#### CPU + motherboard

* CPU:
  * Choose a modern CPU with enough cores for “everything else” (containers, encoding, downloads, indexing), but don’t overspend.
  * If you want to troubleshoot easily, an iGPU can be useful (display output when the GPU is busy or missing).
* Motherboard:
  * Make sure you have a full x16 slot for the GPU.
  * Prefer **2.5GbE** (or plan for a 2.5/10GbE NIC).
  * Enough M.2 slots for NVMe drives.
  * Enough SATA ports if you plan to add HDDs for bulk storage.

Example part names:

* CPU: AMD Ryzen 7 7700
* CPU: Intel Core i5-13500
* Motherboard: ASUS TUF Gaming B650-PLUS
* Motherboard: MSI MAG B760 Tomahawk WiFi

#### RAM

* Minimum comfortable: **32GB**.
* Recommended if you run many services: **64GB**.
* Prefer 2 sticks (dual-channel). Example: 2x16GB or 2x32GB.

Example part names:

* Corsair Vengeance DDR5 64GB (2x32GB)
* Kingston Fury Beast DDR4 32GB (2x16GB)

#### Storage layout (fast + big)

* **NVMe 1–2TB** (or more) for:
  * Docker volumes
  * model cache
  * temp/work directories
  * active projects
* **HDD/SSD bulk storage** for outputs and archives
* Optional but helpful:
  * a separate SSD for OS (keeps OS stable if you stress the data disk)

Example part names:

* NVMe: Samsung 990 PRO
* NVMe: WD Black SN850X
* HDD: Seagate IronWolf

#### PSU (power supply)

* Don’t guess—use a PSU wattage calculator as a sanity check.
* Rules of thumb:
  * Choose a **quality** PSU (reliability matters more than a small price difference).
  * Aim for headroom (you don’t want the PSU at 95–100% load during long jobs).
  * GPU-heavy builds often end up around **750W–1000W** depending on the GPU.

Example part names:

* Corsair RM850x
* Seasonic Focus GX-850

#### Case + cooling (stability = performance)

* Pick a case with:
  * good airflow
  * room for your GPU
  * enough drive bays if you plan storage expansion
* Cooling tips:
  * front intake + rear/top exhaust is the usual pattern
  * keep cables tidy (airflow)
  * use dust filters and clean them regularly

Example part names:

* Case: Fractal Design Define 7
* Case: NZXT H7 Flow
* CPU Cooler: Noctua NH-D15
* Case Fan: Noctua NF-A12x25

#### Network gear

* Ethernet is strongly preferred over Wi‑Fi for servers.
* If you’ll move lots of videos/models between machines:
  * consider 2.5GbE or 10GbE (switch + NICs)

Example part names:

* NIC (2.5GbE): Realtek RTL8125
* NIC (10GbE): Intel X520-DA2
* Switch (2.5GbE): TP-Link TL-SG108-M2

#### UPS (strongly recommended)

* A UPS helps avoid:
  * filesystem corruption
  * interrupted long renders
  * random reboots during updates
* If using a UPS, also configure automatic shutdown.

Example part names:

* APC Back-UPS Pro
* CyberPower CP1500PFCLCD

### Example build tiers (choose one and adjust)

These are “directional” tiers so you can decide where you want to land.

* **Budget / starter**
  * GPU: 12GB VRAM
  * RAM: 32GB
  * NVMe: 1TB
  * Goal: learn the stack, smaller jobs
* **Mid-range (recommended for serious use)**
  * GPU: 16GB VRAM
  * RAM: 64GB
  * NVMe: 2TB
  * Goal: stable daily usage, multiple services
* **High-end / heavy workloads**
  * GPU: 24GB+ VRAM
  * RAM: 64–128GB
  * NVMe: 2–4TB
  * Goal: higher resolution, longer clips, less “out of memory” pain

### Networking: LAN vs internet exposure

* **LAN access**: services reachable only from inside your house.
* **Internet access**: services reachable from outside; requires safe design.
* You have two good patterns:
  1. **VPN first (recommended)**: connect your laptop/phone into your home network, then access services as-if you’re local.
  2. **Reverse proxy + HTTPS**: expose only a few web services through a proxy like Caddy/Traefik/Nginx with TLS.

### Docker (why you want it)

Docker lets you:

* keep services isolated
* upgrade/rollback easily
* avoid “dependency hell” for AI stacks
* run GPU-enabled workloads with NVIDIA Container Toolkit

### Security basics you must follow

* **Don’t expose random ports to the internet**.
* Use **least privilege** (non-root containers when possible, separate users).
* Keep **automatic security updates** and a firewall.
* Use **HTTPS** for web apps.
* Back up your configs and data.

---

## 🛠️ How to Use It (Step-by-Step)

Below is a practical “baseline” setup that works well for most home AI servers.

### 1) Pick a baseline architecture

You’ll usually want:

* **OS**: Ubuntu Server LTS (simple) or Debian (stable)
* **Services**: Docker + Docker Compose
* **Remote access**: Tailscale (easy) OR WireGuard (standard) OR reverse proxy
* **AI stack**: a web UI / API + model storage + a jobs directory

### 1.5) Assemble the server (hardware build checklist)

If you’re building the machine yourself, use this section as a practical checklist.

#### Before you start

* Work on a clean table with good light.
* Reduce static electricity:
  * touch a grounded metal object often, or use an anti-static wrist strap
* Tools to have:
  * Phillips screwdriver
  * thermal paste (if your cooler doesn’t have pre-applied paste)
  * zip ties / Velcro straps for cable management

#### Step-by-step assembly

1. **Prepare the case**

  Install motherboard standoffs in the correct pattern (ATX/mATX). Install case fans (front intake, rear/top exhaust).

2. **Install CPU on the motherboard**

  Open the socket, align the CPU triangle marker, gently seat it.

3. **Install RAM**

  Use the recommended slots for dual-channel (check motherboard manual).

4. **Install NVMe SSD(s)**

  Install in the preferred M.2 slot (some boards have a “primary” slot). Attach the M.2 heatsink if provided.

5. **Mount the CPU cooler**

  Apply paste if needed (a pea-sized dot is a common approach). Connect the fan to CPU_FAN header.

6. **Install the motherboard into the case**

  Align with I/O shield (if separate). Screw it down to standoffs (don’t overtighten).

7. **Install the PSU**

  Orient fan correctly (depends on case airflow design). Connect the 24‑pin ATX cable to the motherboard and the 8‑pin (or 8+4) CPU EPS cable to the motherboard.

8. **Install the GPU**

  Put it in the primary PCIe x16 slot. Connect the required PCIe power cables (don’t mix/force connectors).

9. **Connect case cables**

  Connect front panel (power switch, reset, LEDs), USB headers, and audio header (optional).

10. **Cable management + airflow check**

   Keep GPU intake/exhaust unobstructed. Ensure fans face the right direction.

#### First boot + BIOS/UEFI setup

1. Boot into BIOS/UEFI.
2. Verify hardware:

  CPU detected, total RAM detected, NVMe drives detected, and CPU temperature looks reasonable at idle.

3. Apply key settings:

* enable XMP/EXPO (RAM profile) if you want rated RAM speed
* set boot order (USB first for OS install)
* update BIOS/UEFI if you have stability issues (optional but common)

#### Quick burn-in tests (catch problems early)

Do these before you trust the machine for long AI jobs.

* Memory test (bootable): Memtest86 / Memtest86+
* Linux quick checks (after OS install):

```sh
# CPU stress (install tool first depending on distro)
stress-ng --cpu 0 --timeout 10m

# Watch temps while stressing
watch -n 1 sensors
```

```text
If you see random reboots, GPU driver crashes, or temperatures going out of control,
fix hardware/cooling/power before you invest time downloading models and building a stack.
```

### 2) Install Linux and do initial hardening

After OS install:

1. Create a non-root admin user.
2. Enable SSH.
3. Disable password auth for SSH, use keys.
4. Turn on the firewall.

Example (Ubuntu/Debian style):

```sh
# create user and add to sudo
sudo adduser ai
sudo usermod -aG sudo ai

# basic firewall: allow SSH
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status
```

SSH hardening (edit `/etc/ssh/sshd_config` carefully):

```text
PasswordAuthentication no
PermitRootLogin no
```

Then restart SSH:

```sh
sudo systemctl restart ssh
```

### 3) Install Docker + Docker Compose

Install Docker using your distro’s recommended method. After install, let your user run Docker:

```sh
sudo usermod -aG docker $USER
newgrp docker
docker version
```

### 4) (If you have NVIDIA GPU) install drivers + NVIDIA Container Toolkit

This is what lets Docker containers use your GPU.

Checklist:

1. Install NVIDIA driver
2. Confirm `nvidia-smi` works
3. Install NVIDIA Container Toolkit
4. Confirm a container can see the GPU

GPU test example:

```sh
nvidia-smi
```

Then validate Docker GPU access (example image):

```sh
docker run --rm --gpus all nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi
```

If this fails, don’t continue with AI containers yet—fix GPU runtime first.

### 5) Decide how you’ll access it from the internet

#### Option A — VPN (recommended): Tailscale

Why it’s great:

* no port forwarding required
* works behind CGNAT for many ISPs
* simple access from phone/laptop

Steps:

1. Install Tailscale on the server.
2. Log in.
3. Access services via the server’s Tailscale IP.

Example flow:

```text
Laptop/Phone --(tailscale vpn)--> Home Server
```

#### Option B — Reverse proxy with HTTPS (public web access)

Use this if you want a public URL like `ai.yourdomain.com`.

You’ll need:

* a domain (or dynamic DNS)
* router port-forwarding (usually 80/443) OR a tunnel solution
* a reverse proxy (Caddy is beginner-friendly)
* strong authentication in front of AI UIs

If you’re new: start with VPN first, then add a reverse proxy later.

### 6) Create a standard folder layout

Keep everything under one directory. Example:

```text
/srv
  /stack
    docker-compose.yml
    .env
  /data
    /models
    /outputs
    /work
    /logs
```

Create it:

```sh
sudo mkdir -p /srv/stack /srv/data/{models,outputs,work,logs}
sudo chown -R $USER:$USER /srv/stack /srv/data
```

### 7) Bring up an “AI gateway” + a sample AI service (Compose)

There are many valid stacks. The goal here is to show a repeatable pattern:

* 1 reverse proxy / gateway (optional if VPN-only)
* 1 AI service
* persistent volumes for models/outputs

Example `docker-compose.yml` skeleton you can adapt:

```yaml
services:
  # Optional: reverse proxy. If you use VPN-only, you can skip this.
  caddy:
    image: caddy:2
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
      - caddy_config:/config
    restart: unless-stopped

  # Example placeholder service to prove networking works.
  whoami:
    image: traefik/whoami
    restart: unless-stopped

volumes:
  caddy_data:
  caddy_config:
```

Run it:

```sh
cd /srv/stack
docker compose up -d
docker compose ps
```

Once you can reliably deploy *any* service, adding AI services becomes “just another container”, with extra GPU flags.

---

## 💡 Practical Examples

### Example 1: VPN-only access (safe default)

Goal: You don’t expose any ports except SSH (or even SSH can be VPN-only). You connect via VPN and open private service URLs.

```text
When you access an AI web UI, it’s only reachable over VPN, which avoids most internet scanning and brute-force traffic.
```

Practical pattern:

* Run AI web UI on `http://127.0.0.1:3000` or `http://0.0.0.0:3000` locally on the server
* Use Tailscale to reach `http://<tailscale-ip>:3000` from your laptop

### Example 2: Reverse proxy with HTTPS + basic auth in front

Goal: You want a public domain, but you still want a “gate”.

Example `Caddyfile` skeleton:

```caddyfile
ai.example.com {
 # Good: protect the UI. Prefer SSO/OAuth later if you can.
 basicauth {
  # Generate hashes using: caddy hash-password
  user $2a$14$REPLACE_WITH_BCRYPT_HASH
 }

 reverse_proxy whoami:80
}
```

```text
When you’re ready to expose a real AI service, point reverse_proxy to that container.
Keep the service itself off the public internet; expose only through Caddy.
```

### Example 3: GPU-enabled container pattern

Most AI containers need:

* `--gpus all` (or the compose equivalent)
* model and output directories mounted
* shared memory tweaks sometimes (`shm_size`)

Docker Compose pattern:

```yaml
services:
 ai-service:
  image: your-ai-image
  deploy:
   resources:
    reservations:
     devices:
      - driver: nvidia
       count: all
       capabilities: [gpu]
  volumes:
   - /srv/data/models:/models
   - /srv/data/outputs:/outputs
  environment:
   - NVIDIA_VISIBLE_DEVICES=all
   - NVIDIA_DRIVER_CAPABILITIES=compute,utility
  restart: unless-stopped
```

```text
This is the core “contract”: container can see the GPU and has persistent storage.
The specifics of video generation (ComfyUI nodes, model names, pipelines) can change later.
```

---

## ✅ Best Practices

* **Start with VPN-only**, then add public access if you truly need it.
* Put everything in **Docker Compose** and commit your compose + configs to git (without secrets).
* Use a `.env` file for settings and keep secrets out of the repo.
* Use **separate networks**: expose only the reverse proxy to the outside.
* Enable **automatic security updates** (especially on internet-facing servers).
* Keep models and outputs on dedicated storage; AI workloads can fill disks fast.
* Monitor:
  * GPU: `nvidia-smi`
  * Disk: `df -h`, `ncdu`
  * Logs: container logs, reverse proxy logs
* Backups:
  * back up `/srv/stack` (compose + configs)
  * back up important data in `/srv/data` (or at least outputs)

---

## ⚠️ Common Pitfalls & Warnings

* **Port-forwarding random services**: exposing AI web UIs directly is asking for trouble.
* **No auth in front of web UIs**: many AI UIs were not designed for hostile internet.
* **GPU stack mismatch**: driver/CUDA/container runtime mismatch causes confusing failures.
* **PSU problems**:
  * not enough wattage/headroom
  * missing the right GPU power connectors
  * using cheap adapters (avoid if possible)
* **Thermal throttling**: poor airflow can make a fast GPU behave like a slow one.
* **RAM instability**:
  * aggressive XMP/EXPO settings can cause random crashes
  * if you get weird errors, try disabling XMP/EXPO as a test
* **Running everything as root**: increases blast radius.
* **Disk fills silently**: video outputs + model caches can eat storage quickly.
* **CGNAT/ISP limitations**: you might not be able to host public services with port forwarding.
  * Workaround: VPN (Tailscale), or tunnels, or a cheap VPS as a gateway.
* **No UPS**: power loss can corrupt data; consider a UPS for always-on servers.

---

## 📂 Related Files & Further Learning

### Workspace files

* `${workspaceFolder}/notes/home-server/README.md`
* `${workspaceFolder}/notes/svn/svn.md`
* `${workspaceFolder}/notes/trunk/README.md`

### External resources

* <https://docs.docker.com/engine/install/>
* <https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/>
* <https://tailscale.com/kb/>
* <https://caddyserver.com/docs/>
