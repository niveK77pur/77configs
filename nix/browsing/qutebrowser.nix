{
  lib,
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
      enable = true;
      settings = {};
    };
  };
}
