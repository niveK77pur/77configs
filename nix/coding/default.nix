{
  pkgs,
  alejandra,
  system,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      alejandra.defaultPackage.${system}
    ];

    programs.lazygit.enable = true;
    programs.ripgrep.enable = true;

    programs.git = {
      enable = true;
      userEmail = "kevinbiewesch@yahoo.fr";
      userName = "Kevin Laurent Biewesch";
      # delta.enable = true;
      diff-so-fancy.enable = true;
      # difftastic.enable = true;
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      # withNodeJs = true;
      # withPython3 = true;
    };
  };
}
