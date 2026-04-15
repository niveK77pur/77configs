{
  lib,
  config,
  ...
}: let
  cfg = config.sioyek;
in {
  options.sioyek = {
    enable = lib.mkEnableOption "sioyek";
  };

  config = lib.mkIf cfg.enable {
    programs.sioyek = {
      enable = true;
    };
  };
}
