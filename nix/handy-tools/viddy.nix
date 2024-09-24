{
  pkgs,
  lib,
  config,
  ...
}: {
  options.viddy.enable = lib.mkEnableOption "viddy";
  config = lib.mkIf config.viddy.enable {
    home.packages = with pkgs; [
      viddy
    ];

    # xdg.configFile."viddy.toml".source = ../../config/viddy.toml;
  };
}
