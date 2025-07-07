{
  lib,
  config,
  wrapNixGL,
  ...
}: let
  cfg = config.qutebrowser;
in {
  options.qutebrowser = {
    enable = lib.mkEnableOption "qutebrowser";
    package = lib.mkOption {
      type = lib.types.package;
      default = wrapNixGL {
        binName = "qutebrowser";
        inherit config;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.qutebrowser = {
      inherit (cfg) package;
      enable = true;
      settings = {};
    };
  };
}
