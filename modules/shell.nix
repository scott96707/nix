{ pkgs, ... }: {
  programs.zsh.enable = true;

  programs.starship = {
    enable = true;
    # Custom settings for Starship
    settings = {
      add_newline = false;
      format = "$username$hostname$directory$git_branch$python$kubernetes$character";
      
      directory = {
        style = "bold blue";
      };
      
      hostname = {
        ssh_only = false;
        format = "@[$hostname]($style) ";
        style = "bold magenta";
      };

      python = {
        format = "via [🐍 $version]($style) ";
      };
    };
  };
}
