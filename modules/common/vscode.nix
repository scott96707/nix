{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      
      # 1. Official Extensions
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        eamodio.gitlens
        ms-azuretools.vscode-docker
        ms-python.python
        ms-toolsai.jupyter
        oderwat.indent-rainbow
      ] 
      # 2. Marketplace Extensions
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-edit-csv";
          publisher = "janisdd";
          version = "0.8.2";
          sha256 = "sha256-DbAGQnizAzvpITtPwG4BHflUwBUrmOWCO7hRDOr/YWQ=";
        }
      ];

      userSettings = {
        "editor.fontSize" = 14;
        "editor.formatOnSave" = true;
        "files.autoSave" = "onFocusChange";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "python.defaultInterpreterPath" = "${pkgs.python3}/bin/python";
      };
      
    };
  };
}
