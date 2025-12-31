{ config, pkgs, lib, inputs, ... }:

{
  # Machine-specific identity
  home.username = "work_machine";
  home.stateVersion = "24.11";

  # Shared Modules
  imports = [
    ./../../modules/macbook/git.nix
    ./../../modules/common/neovim.nix
    ./../../modules/common/shell.nix
    ./../../modules/common/vscode.nix
    ./../../modules/common/wezterm.nix

    inputs.sops-nix.homeManagerModules.sops
  ];

  # macOS Specific session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # macOS Specific Aliases
  home.shellAliases = {
    cleanup = "nix-collect-garbage -d";
    rebuild = "sudo darwin-rebuild switch --flake ~/nixos-config#macbook";
  };

  # Packages for the Mac
  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    htop
    tree
  ];

  programs.home-manager.enable = true;
  programs.bash.enable = true;

  # Create a Launch Agent to start Rectangle on login
  launchd.agents.start-rectangle = {
    enable = true;
    config = {
      ProgramArguments = [ "/usr/bin/open" "-a" "Rectangle" ];
      RunAtLoad = true;
      KeepAlive = false;     # Don't restart it if I quit it manually
      ProcessType = "Interactive";
    };
  };

  # SOPS configuration
  sops = {
    defaultSopsFile = ./../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    
    age.keyFile = "/Users/work_machine/.config/sops/age/keys.txt";

    secrets.git-name = {};
    secrets.git-email = {};

    # This creates the file at ~/.config/sops-nix/secrets/templates/git-user.conf
    templates."git-user.conf".content = ''
      [user]
        name = ${config.sops.placeholder.git-name}
        email = ${config.sops.placeholder.git-email}
    '';
  };
}
