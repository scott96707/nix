# Declarative Infrastructure (NixOS & macOS)

This repository contains the **Infrastructure as Code (IaC)** for my personal workstations. It uses [Nix Flakes](https://nixos.wiki/wiki/Flakes) to share configurations, development tools, and dotfiles between a **NixOS Desktop** (Linux/AMD GPU) and a **MacBook** (macOS/Intel).

It is designed to provide a reproducible **Engineering environment**, featuring a unified terminal experience, consistent keybindings, and automated state management.

## 🏗 Architecture

The configuration is organized into a modular structure:

```markdown
├── flake.nix               # Entry point & dependency pinning (Nixpkgs 25.11)
├── flake.lock              # Exact package version lockfile
├── hosts/                  # Machine-specific configurations
│   ├── macbook/            # macOS Laptop (nix-darwin)
│   │   ├── configuration.nix
│   │   └── home.nix
│   └── nixos/              # Linux Desktop (GNOME/Wayland + AMD ROCm)
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── home.nix
├── modules/                # Modular logic blocks
│   ├── common/             # Shared (NVIM, Shell, WezTerm, VSCode)
│   ├── macbook/            # macOS-only (Git identity)
│   └── nixos/              # Linux-only (Firefox, GPU-specific Git)
└── secrets/                # SOPS-managed encrypted secrets
```

## 🚀 Features

* **OS Management**: Fully declarative system state. If I wipe a machine, this repo restores it 100%.
* **Hybrid Storage**:
* **Cloud**: Encrypted Google Drive via Rclone VFS with optimized caching.
* **Local**: Automated, "self-healing" NTFS mounts for internal storage (The "Mule") with `systemd.automount`.


* **Terminal**: [WezTerm](https://wezfurlong.org/wezterm/) configured with **JetBrains Mono** and **Catppuccin** themes.
* **Editor**: [VS Code](https://code.visualstudio.com/) and [Neovim](https://neovim.io/) with custom Nix-managed configurations.
* **Networking**: Samba (SMB) configuration optimized for macOS interoperability and Avahi (Bonjour) discovery.

---

## 🔐 Secrets & Bootstrap (SOPS)

This configuration uses [sops-nix](https://github.com/Mic92/sops-nix) for secret management.

**Mandatory Requirement:**
Before applying a configuration for the first time, you must manually place your decryption key at the following location:
` /var/lib/sops-nix/key.txt`

If this file is missing, the `rebuild` command will fail to evaluate.

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



### Storage Maintenance

If the internal **Mule** drive becomes unreachable or "dirty" due to a hard reset:

```bash
# Force repair the NTFS metadata
sudo ntfsfix -d /dev/disk/by-label/Mule

```

### Manual Cloud Sync

For large data transfers where the VFS mount is not ideal:

```bash
nix shell nixpkgs#rclone --command rclone sync -P /local/path secret:

```

---

## 🐧 Installation on NixOS (Linux)

1. **Partition & Install**: Minimal install with user `home`.
2. **Clone & Setup**:
```bash
git clone [https://github.com/scott96707/nixos-config](https://github.com/scott96707/nixos-config) ~/nixos-config

```


3. **Hardware Config**: Copy `/etc/nixos/hardware-configuration.nix` into `~/nixos-config/hosts/nixos/`.
4. **Secrets**: Ensure your `key.txt` is in `/var/lib/sops-nix/`.
5. **Apply**: `sudo nixos-rebuild switch --flake ~/nixos-config#nixos`

---

## 🍎 Installation on macOS

1. **Install Nix**: Via [Determinate Systems](https://install.determinate.systems/nix).
2. **Enable Flakes**: Add `experimental-features = nix-command flakes` to `~/.config/nix/nix.conf`.
3. **Apply**: `nix run nix-darwin -- switch --flake ~/nixos-config#macbook`
