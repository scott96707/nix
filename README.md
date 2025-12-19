# Declarative Infrastructure (NixOS & macOS)

This repository contains the **Infrastructure as Code (IaC)** for my personal workstations. It uses [Nix Flakes](https://nixos.wiki/wiki/Flakes) to share configurations, development tools, and dotfiles between a **NixOS Desktop** (Linux/AMD GPU) and a **MacBook** (macOS/Intel).

It is designed to provide a reproducible **Engineering environment**, featuring a unified terminal experience, consistent keybindings, and automated system state management.

## 🏗 Architecture

The configuration is organized into a modular structure:

```text
├── flake.nix             # Entry point & dependency pinning (Nixpkgs 25.11)
├── flake.lock            # Exact package version lockfile
├── hosts/                # Machine-specific configurations
│   ├── nixos/            # Linux Desktop (GNOME/Wayland + AMD ROCm)
│   └── macbook/          # macOS Laptop (nix-darwin)
├── modules/              # Shared configurations
│   ├── common.nix        # Packages common to both OSs (Git, Ripper, etc.)
│   ├── neovim.nix        # Lua-based Neovim setup (LSP, Treesitter, Themes)
│   ├── wezterm.nix       # GPU-accelerated terminal config
│   ├── git.nix           # Git identity & SSH signing
│   └── shell.nix         # Zsh, Starship, and aliases

```

## 🚀 Features

* **OS Management**: Fully declarative system state. If I wipe a machine, this repo restores it 100%.
* **Terminal**: [WezTerm](https://wezfurlong.org/wezterm/) configured with **JetBrains Mono** and **Catppuccin** themes.
* **Editor**: [Neovim](https://neovim.io/) with a custom Lua configuration, managing plugins via Nix.
* **Shell**: Zsh with [Starship](https://starship.rs/) prompt and [Direnv](https://direnv.net/) integration.
* **Linux**: Kernel pinned for AMD GPU support (`amdgpu`), ROCm, and hardware acceleration.
* **macOS**: System-level UI tweaks (opaque menu bar), Homebrew integration, and window management via Rectangle.



---

## 🍎 Installation on macOS

**Prerequisites:** A fresh install of macOS (Sonoma/Sequoia).

### 1. Install Nix

The official installer creates the volume and users required for Nix.

```bash
sh <(curl -L [https://nixos.org/nix/install](https://nixos.org/nix/install))

```

### 2. Enable Flakes

Edit your global Nix config to enable the modern command set:

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

```

### 3. Bootstrap

Clone this repo and apply the configuration. Nix-Darwin will take over system management from here.

```bash
# Clone the repo
git clone [https://github.com/scott96707/nixos-config](https://github.com/scott96707/nixos-config) ~/nixos-config

# Build and Switch
# Note: "macbook" matches the name in flake.nix
nix run nix-darwin -- switch --flake ~/nixos-config#macbook

```

---

## 🐧 Installation on NixOS (Linux)

**Prerequisites:** Boot the machine with the [NixOS 25.11 ISO](https://nixos.org/download.html).

### 1. Partition & Install Minimal OS

Perform a standard graphical or manual install. When prompted for a user, use `home` (or update `hosts/nixos/configuration.nix` to match your chosen username).

### 2. Preserve Hardware Config

NixOS generates a unique `hardware-configuration.nix` for your specific drives and CPU.

```bash
# Back up the generated hardware config
cp /etc/nixos/hardware-configuration.nix ~/hardware-configuration.nix.bak

```

### 3. Clone & Setup

```bash
# Clone the repo
git clone [https://github.com/scott96707/nixos-config](https://github.com/scott96707/nixos-config) ~/nixos-config

# Copy your hardware config into the host directory
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/nixos/
git add ~/nixos-config/hosts/nixos/hardware-configuration.nix

```

### 4. Apply Configuration

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#nixos

```

---

## 🛠 Usage & Cheatsheet

### The `rebuild` Command

This config installs a universal alias called `rebuild` that automatically detects the OS and runs the correct switch command.

* **Apply Changes:**
```bash
rebuild

```


* **Update System (Fetch latest packages):**
```bash
nix flake update
rebuild

```


* **Clean Garbage (Free up disk space):**
```bash
# Removes old generations older than 7 days
sudo nix-collect-garbage -d

```



## 🔐 Secrets & Signing

This configuration expects an SSH key at `~/.ssh/id_ed25519` for Git commit signing.

```bash
# Generate key if missing
ssh-keygen -t ed25519 -C "your_email@example.com"

```

```

```
