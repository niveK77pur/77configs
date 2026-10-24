{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.limo;
in {
  options.limo = {
    enable = lib.mkEnableOption "limo";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.limo];
    reshade-steam-proton.enable = true;
  };
}
