# Novin Device Structure (Draft)

```mermaid
flowchart TD
root["/"]

root --> control_board
root --> ui_board["ui_board/"]
root --> deploy["deploy/"]

ui_board --> base["device/"]
base --> code_device_families(("like grand, metrix"))
base --> code_shared["shared/"]
code_shared --> code_shared_frontend["frontend/"]
code_shared --> code_shared_backend["backend/"]
code_device_families --> code_devices(("like 350g, 870m"))
code_devices --> device_arch_type(("like rpi, rockchip"))

ui_board --> non_device["non_device/"]
non_device --> installer["InstallerApp/"]
non_device --> updater["OnlineUpdater/"]

%% Logic-level team separation
device_arch_type --> logic_frontend["frontend/"]
device_arch_type --> logic_backend["backend/"]
device_arch_type --> logic_version{"VERSION"}
device_arch_type --> logic_deploy{"deploy.sh"}

deploy --> images["images/"]
deploy --> cross_builds["cross_builds/"]
deploy --> resources["resources/"]
deploy --> scripts["scripts/"]

images --> arch_images(("like rpi, rockchip"))
arch_images --> img_device_families(("like grand, metrix"))
img_device_families --> img_devices(("like 350g, 870m"))
img_devices --> image_file{"image files with different display sizes"}

cross_builds --> cb_type(("like rpi, rockchip"))
cb_type --> cb_rpi_sysroot["sysroot/"]
cb_type --> cb_rpi_qt["qt/"]
cb_type --> cb_rpi_toolchain["toolchain/"]
cb_type --> cb_rpi_binaries["binaries/"]
scripts --> build["build.sh"]

resources --> res_type(("like rpi, rockchip"))
res_type --> rpi_config{"config.txt"}
res_type --> rpi_firmware{"firmware.bin"}

scripts --> deploy_script["deploy.sh"]

installer --> install_deploy["deploy.sh"]
updater --> update_deploy["deploy.sh"]
```

> Note: All device frontend/backend use shared code

---

Option 1: Board-Centric Structure

```
device_x/
  ui_board/
    frontend/
    backend/
    bridge/
    VERSION
    deploy.sh
  control_board/
    firmware/
    drivers/
    VERSION
    deploy.sh
  shared/
    protocol/
    utils/
```

Option 2: Function-Centric Structure

```
device_x/
  frontend/         # UI code for UI board
  backend/          # Backend/bridge code for UI board
  control_firmware/ # Low-level control board code
  shared/           # Shared code (protocols, utils)
  deploy/
    ui_board.sh
    control_board.sh
```

Option 3: Board-Type Separation at Higher Level

```
code/
  ui_boards/
    device_x/
      frontend/
      backend/
      bridge/
  control_boards/
    device_x/
      firmware/
      drivers/
  shared/
    protocol/
    utils/
```

Option 4: Versioned Device Structure (as in your draft, but with board split)

```
code/
  device_x/
    ui_board/
      frontend/
      backend/
      bridge/
    control_board/
      firmware/
      drivers/
    shared/
      protocol/
      utils/
```

Key Points:

- Separate UI/bridge and control board code for clarity and team ownership.
- Use a shared directory for protocol definitions and utilities used by both boards.
- Keep deployment scripts and versioning per board if their release cycles differ.
- Consider mirroring this structure for each device type/version.

Let me know if you want a specific option detailed or adapted to your naming conventions!

Here are some naming options for the two board types in your directory structure:

For UI Boards:

- ui_board
- bridge_board
- main_board
- application_board
- interface_board
- host_board
- master_board

For Control Boards:

- control_board
- logic_board
- mcu_board
- slave_board
- hardware_board
- peripheral_board
- device_board

You can mix and match based on your team's preference and the terminology used in your documentation or hardware. For example: ui_board & control_board, main_board & logic_board, or bridge_board & mcu_board.
