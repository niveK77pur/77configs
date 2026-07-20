{
  lib,
  config,
  ...
}: let
  cfg = config.clipse;
in {
  options.clipse = {
    enable = lib.mkEnableOption "clipse";
  };

  config = lib.mkIf cfg.enable {
    services.clipse = {
      enable = true;
      settings.imageDisplay = {
        type = "sixel";
      };
    };
  };
}
