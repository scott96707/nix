{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      # Official Extensions in pkgs.vscode-extensions
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        eamodio.gitlens
        ms-azuretools.vscode-docker
        ms-python.python
        ms-toolsai.jupyter
        oderwat.indent-rainbow
      ] 
      # Marketplace Extensions not packaged in pkgs.vscode-extensions
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-edit-csv";
          publisher = "janisdd";
          version = "0.8.2";
          sha256 = "sha256-DbAGQnizAzvpITtPwG4BHflUwBUrmOWCO7hRDOr/YWQ=";
        }
        {
          name = "chatgpt";
          publisher = "openai";
          version = "0.5.56";
          sha256 = "sha256-FAy2Cf2XnOnctBBATloXz8y4cLNHBoXAVnlw42CQzN8=";
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
