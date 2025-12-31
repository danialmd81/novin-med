# device_cpm

## Overview

Medical device application for the CPM device, running on Raspberry Pi.

## Architecture

- **UI:** QML files in `qml/` for the user interface.
- **Core Logic:** C++ for device control, data management, and protocol handling.
- **Hardware Abstraction:** GPIO/serial via macros in `general/include/adefs.h`.
- **Resources:** Device and shared assets in `resources/` and `shared_resources/`.

## Directory Structure

- `qml/` – QML UI root
- `resources/` – Images, icons, JS helpers
- `main.cpp` – Application entry point
- `.pro` – Qt project configuration

## Build Instructions

- Qt 5.x/6.x, Linux (Raspberry Pi)
- Build:

  ```sh
  qmake && make
  ```

## Run Instructions

- Deploy binary to Raspberry Pi device.
- Set `DEFINES += RASPBERRY_7INCH` or `DEFINES += RASPBERRY_10INCH` in `.pro` as needed.

## Notes / Limitations

- Designed for CPM medical hardware.
- Ensure medical compliance for therapy use.
