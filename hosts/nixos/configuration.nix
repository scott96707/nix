{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/common.nix
    ];

  # --- BOOT & KERNEL ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Filesystems & Drivers
  boot.supportedFilesystems = [ "ntfs" "ntfs3" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "amdgpu" ];

  # GPU/Display fixes
  boot.kernelParams = [
    "amdgpu.si_support=1"
    "radeon.si_support=0"
    "amdgpu.dc=1"
  ];

  # --- HARDWARE & GPU ---
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.enableRedistributableFirmware = true;

  # --- AUDIO FIXES (Wireplumber) ---
  environment.etc."wireplumber/main.lua.d/51-hdmi-priority.lua".text = ''
    alsa_monitor.rules = alsa_monitor.rules or {}
    table.insert(alsa_monitor.rules, 1, {
      matches = {
        { { "node.name", "matches", "alsa_output.pci-0000_0c_00.1.hdmi-stereo" } },
      },
      apply_properties = {
        ["priority.session"] = 2000,
      }
    })
  '';

  # --- STORAGE & MOUNTS ---
  services.fstrim.enable = true;

  fileSystems."/drives/aming" = {
    device = "/dev/disk/by-uuid/60F8ABD5F8ABA7AC";
    fsType = "ntfs3";
    options = [ "nofail" "uid=1000" "gid=100" ];
  };

  fileSystems."/drives/mule" = {
    device = "/dev/disk/by-label/Mule";
    fsType = "ntfs3";
    options = [ "nofail" "uid=1000" "gid=100" ];
  };

  # --- NETWORKING ---
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    # IMPORTANT: Open 445/TCP (SMB) and 139/TCP (NetBIOS)
    allowedTCPPorts = [ 445 139 5357 ];
    allowedUDPPorts = [ 137 138 3702 ]; 
  };
  
  # Specific Locale Overrides (Common sets defaults, this overrides specific formats)
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # --- DESKTOP ENVIRONMENT ---
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true; 
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb = { layout = "us"; variant = ""; };

  # Auto Login
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "home";

  # Disable TTY getters to prevent boot race conditions
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Google Drive Service
  systemd.services.google-drive-mount = {
    description = "Mount Google Drive (Secret) via Rclone";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      User = "home"; 
      Group = "users";
      ExecStartPre = [
        "-/run/wrappers/bin/fusermount -uz /home/home/mnt/google_secret" 
        "${pkgs.coreutils}/bin/mkdir -p /home/home/mnt/google_secret"
      ]; 
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount secret: /home/home/mnt/google_secret \
          --config=/home/home/.config/rclone/rclone.conf \
          --vfs-cache-mode full \
          --allow-non-empty
      '';
      ExecStop = "/run/wrappers/bin/fusermount -u /home/home/mnt/google_secret";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

  # --- USERS ---
  users.users.home = {
    isNormalUser = true;
    description = "home";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # --- HOME MANAGER ---
  # This imports the home.nix that sits RIGHT NEXT to this file
  home-manager.users.home = import ./home.nix;

  # --- HOST SPECIFIC PACKAGES ---
  # GUI Apps and heavy tools specific to this desktop
  environment.systemPackages = with pkgs; [
    efitools
    exiftool
    firefox
    libreoffice 
    mesa 
    mpv 
    rclone
    transmission_4 
    transmission_4-qt
    vlc 
    vulkan-tools
    wezterm
    yt-dlp
    
    # Neovim plugins (Host specific config)
    vimPlugins.nvim-treesitter.withAllGrammars 
    vimPlugins.vim-nix
  ];

  environment.shellAliases = {
    # UPDATED: Points to your new home git repo!
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/#nixos";
    
    cleanup = "sudo nix-collect-garbage -d"; 
    findpkg = "nix-locate --top-level"; 
    vim = "nvim";
    sunvim = "sudo -E nvim"; 
    pbcopy = "wl-copy";
    pbpaste = "wl-paste";
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
  };

  # --- PROGRAMS ---
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.gamemode.enable = true;
  
  programs.git = {
    enable = true;
    config = {
      user = { 
        name = "scott96707";
        email = "scott96707@gmail.com";
      };
      # UPDATED: Allow git to trust your new home repo
      safe.directory = "~/nixos-config";
    };
  };

  services.printing.enable = true;
  zramSwap.enable = true;

  # --- SAMBA (File Sharing) ---
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "nixos";
        "security" = "user";
        "log level" = "1 auth:3"; # Enable Auth Logging
        "logging" = "systemd";
        # Mac Compatibility
        "fruit:metadata" = "stream";
        "fruit:model" = "MacSamba";
        "fruit:posix_rename" = "yes";
        "fruit:veto_appledouble" = "no";
        "fruit:nfs_aces" = "no";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
      };
      
      "mule" = {
        "path" = "/drives/mule";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "home";
      };
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
    extraServiceFiles = {
      smb = ''
        <?xml version="1.0" standalone='no'?><!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
        </service-group>
      '';
    };
  };

  system.stateVersion = "23.05"; 
}
