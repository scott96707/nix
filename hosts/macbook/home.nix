{ config, pkgs, lib, ... }:

{
  # Machine-specific identity
  home.username = "work_machine";
  home.stateVersion = "24.11";

  # Shared Modules
  imports = [
    ./../../modules/wezterm.nix
    ./../../modules/git.nix
    ./../../modules/neovim.nix
    ./../../modules/shell.nix
    ./../../modules/common.nix
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
}
