with import <nixpkgs> {};

let inherit (vimUtils) buildVimPluginFrom2Nix; in {
  
  "horizon" = buildVimPluginFrom2Nix {
    name = "horizon";
    src = fetchgit {
      
      # github repo
      url = "https://github.com/ntk148v/vim-horizon";
    
      # rev/commit hash
      rev = "ca8ca90d14190aeadc352cf9f89c3508c304ec02";
    
      # sha256 hash
      sha256 = "ca8ca90d14190aeadc352cf9f89c3508c304ec02";
    };
  };

  easygrep = pkgs.vimUtils.buildVimPlugin {
    name = "miramare";
    src = pkgs.fetchFromGitHub {
      owner = "franbach";
      repo = "miramare";
      rev = "04330816640c3162275d69e7094126727948cd0d";
      hash = "lib.fakeHash";
    };
  };
  "photon" = buildVimPluginFrom2Nix {
    name = "photon";
    src = fetchgit {
      url = "https://github.com/ntk148v/vim-horizon";
      rev = "ca8ca90d14190aeadc352cf9f89c3508c304ec02";
      sha256 = "ca8ca90d14190aeadc352cf9f89c3508c304ec02";
    };
  };
}
