{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Scott Green";
    userEmail = "scott96707@yahoo.com";
    signing.key = "";
    signing.signByDefault = true;
  };
}
