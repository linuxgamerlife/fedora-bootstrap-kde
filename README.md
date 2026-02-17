# Linux Gamer Life Fedora KDE Bootstrap (AMD)

This repository contains the Linux Gamer Life Fedora Bootstrap script.

It converts a minimal Fedora Everything installation into a complete KDE Plasma desktop with gaming, multimedia, virtualization, and creator tooling using a single script.

The script is designed to run from TTY immediately after installing Fedora Everything Minimal.

This bootstrap reflects my personal Linux Gamer Life workflow and ensures a consistent, repeatable system setup.

---

## Purpose

The goal of this script is to transform a completely minimal Fedora install into a full Linux Gamer Life desktop environment automatically.

This includes:

- KDE Plasma desktop
- Gaming tools
- Multimedia codecs
- Virtualization support
- Flatpak and desktop applications
- Python CLI tooling
- System optimizations

The result is a complete, ready-to-use Linux system after one reboot.

---

## Supported System

Required base installation:

Fedora Everything Minimal

This script is intended to be run after the first boot, from TTY.

---

## How to Run

From TTY after installing Fedora Everything Minimal:

```bash
curl -fsSL https://tinyurl.com/lgl-fedora | sudo bash
```

After completion, reboot:

```bash
reboot
```

The system will boot into KDE Plasma.

---

## What Gets Installed and Configured

### Desktop Environment

- KDE Plasma Desktop
- SDDM display manager
- Graphical boot target enabled

---

### Repository Configuration

Enables required repositories:

- RPM Fusion Free
- RPM Fusion Non-Free
- Fedora Cisco OpenH264 repository
- Flathub Flatpak repository

These repositories enable access to codecs, gaming tools, and applications not included in default Fedora.

---

### Core System Tools

Installed via DNF:

- curl
- wget
- git
- dnf-plugins-core
- fastfetch
- tuned
- xrdp
- btop
- htop
- distrobox

---

### Python and CLI Tooling

Installed via DNF:

- python3
- python3-pip
- pipx

Installed via pipx for the invoking user:

- tldr
- yt-dlp

This allows modern CLI tools to be installed safely outside the system Python environment.

---

### Multimedia and Codec Support

Installs and configures:

- Full ffmpeg (replaces ffmpeg-free)
- VLC media player
- OpenH264 codec support
- Full GStreamer plugin stack
- VA-API hardware acceleration support

Provides full video playback, recording, and encoding capability.

---

### AMD GPU Support

Installs Mesa and Vulkan components:

- mesa-dri-drivers
- mesa-vulkan-drivers
- vulkan-loader
- mesa-va-drivers
- mesa-vdpau-drivers
- linux-firmware

Ensures optimal support for AMD graphics hardware.

---

### Flatpak and Applications

Installs Flatpak and enables Flathub.

Flatpak applications installed:

- Flatseal
- ProtonUp-Qt
- ProtonPlus
- Heroic Games Launcher
- LibreOffice

Provides sandboxed applications and Proton management tools.

---

### Gaming Tools

Installed via RPM:

- Steam
- OBS Studio
- Lutris
- MangoHud

Provides native Linux gaming support and performance tools.

---

### Virtualization Support

Installs full virtualization stack:

- virt-manager
- libvirt
- libvirt-daemon-config-network
- libvirt-daemon-kvm
- qemu-kvm
- virt-install
- virt-viewer
- edk2-ovmf
- swtpm

Configures:

- libvirtd service enabled
- User added to libvirt group

Allows creation and management of virtual machines.

---

### System Tweaks

Applies system optimizations:

- Disables NetworkManager wait online delay to improve boot speed
- Sets graphical target as default boot mode
- Removes unused dependencies
- Cleans package cache

---

## Removed Packages

Removes unwanted packages to keep the system clean:

- Thunderbird
- GNOME Terminal
- GNOME Disks
- File Roller
- Document Scanner
- Document Viewer
- HexChat
- mpv
- Pidgin
- GNOME Software
- Xed
- Xfburn
- Eye of MATE

---

## Script Behavior

The script performs the following steps automatically:

1. Updates the system
2. Enables repositories
3. Installs KDE Plasma
4. Installs Python and CLI tools
5. Installs multimedia codecs
6. Installs AMD graphics support
7. Installs Flatpak and applications
8. Installs gaming tools
9. Installs virtualization tools
10. Applies system tweaks
11. Cleans unused packages

---

## Requirements

- Fedora Everything Minimal installed
- Internet connection
- Must be run using sudo
- Must be run from TTY after installation

---

## After Installation

Reboot the system:

```bash
reboot
```

Login using KDE Plasma.

---

## Target User Handling

The script automatically detects the sudo user and installs user-level tools such as pipx applications for that user.

Virtualization permissions are also applied to that user.

---

## About Linux Gamer Life

This bootstrap represents my personal Linux Gamer Life Fedora setup.

It provides a consistent base for:

- Gaming
- Content creation
- Virtual machines
- Linux testing
- Daily desktop use

---

## License

MIT License
