{ config, pkgs, lib, ... }:

{
  # Machine-specific identity
  home.username = "work_machine";
  home.homeDirectory = "/Users/work_machine";
  home.stateVersion = "24.11";

  # Shared Modules
  imports = [
    ./../../modules/wezterm.nix
    ./../../modules/git.nix
    ./../../modules/neovim.nix
    #./../../modules/firefox.nix
  ];

  # macOS Specific session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # macOS Specific Aliases
  home.shellAliases = {
    hms = "darwin-rebuild switch --flake ~/nixos-config/#macbook";
    cleanup = "nix-collect-garbage -d";
  };

  # Packages for the Mac
  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    htop
    tree
#    vlc
#    libreoffice
  ];

  programs.home-manager.enable = true;
  programs.bash.enable = true;
}
