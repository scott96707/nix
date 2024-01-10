{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../system/macos
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.scottgreen = {config, pkgs, ...}: {
    imports = [
      ../../home/alacritty
      ../../home/zsh
      ../../apps/vim
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "22.11";

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "scottgreen";
    home.homeDirectory = "/Users/scottgreen";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };

  # Setup primary user
  users.users.scottgreen = {
    name = "scottgreen";
    home = "/Users/scottgreen";
  };

  # Add in the experimental nix command line tool and flakes. The nix
  # command 'should' be in the next release of nixos. As for when flakes
  # become mainlined who knows.
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";
  nix.package = pkgs.nix;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # List of installed packages specific to this host.
  environment.systemPackages = with pkgs; [
#    bazel_6
#    cmake
    curl
    dig
#    direnv
#    fd
#    file
#    fzf
    git
#    go
    home-manager
    htop
#    inetutils
#    ispell
    jq
#    lf
#    mediainfo
#    ripgrep
    rectangle
    shellcheck
    tree
    vim-full
    watch
  ];

  # ZSH Basic Configuration
  programs.zsh.enable = true;

  # GPG Configuration
  #programs.gnupg.agent.enable = true;
  #programs.gnupg.agent.enableSSHSupport = true;

  programs.man.enable = true;
}
