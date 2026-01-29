{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.qutebrowser;
in {
  options.qutebrowser = {
    enable = lib.mkEnableOption "qutebrowser";
  };

  config = lib.mkIf cfg.enable {
    programs.qutebrowser = {
      package = config.lib.nixGL.wrap pkgs.qutebrowser;
      enable = true;
      settings = {};
    };
  };
}
