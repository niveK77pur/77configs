{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      viddy
    ];

    # xdg.configFile."viddy.toml".source = ../../config/viddy.toml;
  };
}
