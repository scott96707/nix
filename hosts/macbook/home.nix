{ config, pkgs, ... }:

{
  home.stateVersion = "24.11";
  
  # 1. Import your old modules
  # (Adjust these paths if you change the folder structure)
  imports = [
    ./home-modules/zsh/default.nix
    ./home-modules/git/default.nix
    ./home-modules/alacritty/default.nix
  ];

  # 2. Common Packages
  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    # ... add your tools here
  ];
  
  # 3. Enable Home Manager
  programs.home-manager.enable = true;
}
