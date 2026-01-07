# device_g_760 (Biofeedback)

## Overview

Medical device application for the 760g device, running on Raspberry Pi.

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

## Notes / Limitations

- Designed for 760g medical hardware.
- Ensure medical compliance for therapy use.
- Need Email and Password for device_a_760 feedback server access.
