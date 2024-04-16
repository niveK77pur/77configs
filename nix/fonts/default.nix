{pkgs, ...}: {
  config = {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      gyre-fonts
    ];
  };
}
