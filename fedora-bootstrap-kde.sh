#!/usr/bin/env bash
set -euo pipefail

# Linux Gamer Life Fedora Bootstrap (TTY friendly)
# Goal: Start from Fedora Everything Minimal (TTY), run once, reboot into KDE Plasma.
#
# Installs and configures:
# - KDE Plasma + SDDM
# - RPM Fusion (free + nonfree) + Cisco OpenH264 repo
# - Python tooling: python3, pipx, tldr, yt-dlp (via pipx for the invoking user)
# - Codecs: ffmpeg swap, full GStreamer set, multimedia groups, VA-API bits, OpenH264
# - Gaming: Steam (RPM), OBS (RPM), Lutris, MangoHud
# - Flatpak + Flathub + Flatseal
# - Virtualization: virt-manager + libvirt/KVM stack
# - Fedora Media Writer (extra)
#
# Removes:
# - Thunderbird
# - GNOME Terminal
# - GNOME Disks
# - File Roller, Document Scanner, Document Viewer, HexChat, mpv, Pidgin, GNOME Software
# - Xed, Xfburn, Eye of MATE
#
# Tweaks:
# - Disables NetworkManager-wait-online for faster boot
#
# Run:
#   curl -fsSL https://tinyurl.com/lgl-fedora | sudo bash

# -----------------------------
# Colours (LGL style)
# -----------------------------
GREEN='\033[38;2;0;255;0m'     # #00ff00
ORANGE='\033[38;2;255;153;0m'  # #ff9900
RED='\033[38;2;255;68;68m'     # #ff4444
WHITE='\033[38;2;249;249;249m' # #f9f9f9
RESET='\033[0m'
BOLD='\033[1m'

section() { printf "\n${BOLD}${GREEN}==> %s${RESET}\n" "$1"; }
info() { printf "${WHITE}%s${RESET}\n" "$1"; }
warn() { printf "${BOLD}${RED}Warning:${RESET} ${WHITE}%s${RESET}\n" "$1"; }
cmdhint() { printf "${ORANGE}%s${RESET}\n" "$1"; }

require_root() {
  if [[ ${EUID} -ne 0 ]]; then
    warn "Run with sudo, for example:"
    cmdhint "sudo bash $0"
    exit 1
  fi
}

dnf_group_install_best_effort() {
  local group_name="$1"
  dnf -y group install "${group_name}" || true
}

# The user who invoked sudo is who we should configure for pipx installs.
get_target_user() {
  if [[ -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
    printf "%s" "${SUDO_USER}"
    return
  fi
  # Fallbacks for edge cases
  printf "%s" "$(logname 2>/dev/null || echo root)"
}

printf "${BOLD}${GREEN}Linux Gamer Life Fedora KDE Bootstrap${RESET}\n"
require_root

TARGET_USER="$(get_target_user)"
FEDORA_VERSION="$(rpm -E %fedora)"
info "Detected Fedora version: ${FEDORA_VERSION}"
info "Target user for user-level tooling: ${TARGET_USER}"

# -----------------------------
# 1) Base system + tooling
# -----------------------------
section "Base update and core tools"
dnf -y upgrade --refresh
dnf -y install curl wget git dnf-plugins-core

# -----------------------------
# 2) Repositories
# -----------------------------
section "Enable RPM Fusion (free and nonfree)"
dnf -y install \
  "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
  "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"
dnf -y upgrade --refresh

section "Enable Cisco OpenH264 repo"
dnf config-manager --set-enabled fedora-cisco-openh264 || true
dnf -y upgrade --refresh

# -----------------------------
# 3) Desktop environment
# -----------------------------
section "Install KDE Plasma and SDDM"
info "Installing KDE Plasma desktop environment"
dnf -y group install kde-desktop

info "Enabling SDDM (KDE login manager)"
systemctl enable sddm || true


# -----------------------------
# 4) Python, pipx, and CLI tools
# -----------------------------
section "Python, pipx, and CLI tools"

info "Installing Python and pipx"
dnf -y install python3 python3-pip pipx

info "Ensuring pipx is ready for the target user"
sudo -u "${TARGET_USER}" pipx ensurepath || true

info "Installing tldr and yt-dlp via pipx for the target user"
sudo -u "${TARGET_USER}" pipx install --include-deps tldr || true
sudo -u "${TARGET_USER}" pipx install --include-deps yt-dlp || true

info "Installing other essential tools"
dnf -y install fastfetch tuned xrdp btop htop distrobox

# -----------------------------
# 7) Multimedia and codecs
# -----------------------------
section "Multimedia and codecs"

info "Replace ffmpeg-free with ffmpeg"
dnf swap -y ffmpeg-free ffmpeg --allowerasing || true
dnf -y install vlc || true

info "Enable OpenH264 packages"
dnf -y install openh264 gstreamer1-plugin-openh264 mozilla-openh264 || true

info "Install all GStreamer plugins"
dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} \
  gstreamer1-plugin-openh264 gstreamer1-libav lame\* \
  --exclude=gstreamer1-plugins-bad-free-devel || true

info "Install VA-API related packages"
dnf -y install ffmpeg-libs libva libva-utils

# -----------------------------
# 8) AMD stack (Fedora defaults + extras)
# -----------------------------
section "AMD Mesa and Vulkan stack"
dnf -y install \
  mesa-dri-drivers \
  mesa-vulkan-drivers \
  vulkan-loader \
  mesa-va-drivers \
  mesa-vdpau-drivers \
  linux-firmware

# -----------------------------
# 9) Flatpak + Flathub + Flatpak apps
# -----------------------------
section "Flatpak, Flathub, and Flatpak apps"
dnf -y install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

info "Flatseal"
flatpak install -y flathub com.github.tchx84.Flatseal || true

info "ProtonUp-Qt"
flatpak install -y flathub net.davidotek.pupgui2 || true

info "ProtonPlus"
flatpak install -y flathub com.vysp3r.ProtonPlus || true

info "Heroic Games Launcher"
flatpak install -y flathub com.heroicgameslauncher.hgl || true

info "Libre Office"
flatpak install -y org.libreoffice.LibreOffice || true

# -----------------------------
# 10) Gaming tools
# -----------------------------
section "Gaming tools"
dnf -y install steam obs-studio lutris mangohud || true

# -----------------------------
# 11) Virtualization (virt-manager and KVM)
# -----------------------------
section "Virtualization (virt-manager and KVM)"

info "Installing KVM, libvirt, and virt-manager"
dnf -y install \
  virt-manager \
  libvirt \
  libvirt-daemon-config-network \
  libvirt-daemon-kvm \
  qemu-kvm \
  virt-install \
  virt-viewer \
  edk2-ovmf \
  swtpm

info "Enabling libvirtd service"
systemctl enable --now libvirtd

info "Adding user to libvirt group"
usermod -aG libvirt "${TARGET_USER}"

info "Virtualization setup complete (reboot required for group changes)"

# -----------------------------
# 12) Boot and system tweaks
# -----------------------------
section "Boot and system tweaks"
systemctl disable NetworkManager-wait-online.service || true
systemctl set-default graphical.target


# -----------------------------
# Final cleanup
# -----------------------------
section "Cleanup unused dependencies"

info "Removing unused packages"
dnf -y autoremove || true

info "Cleaning package cache"
dnf -y clean all || true

# -----------------------------
# Finish
# -----------------------------
section "Complete"
info "Bootstrap finished."
info "Reboot to start KDE Plasma:"
cmdhint "reboot"
