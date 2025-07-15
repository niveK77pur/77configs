{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.autoraise;
in {
  options.autoraise = {
    enable = lib.mkEnableOption "autoraise";
    service = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "autoraise-launchd";
          stdOutputPath = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "Which path to put stdout and stderr into, if any";
          };
        };
      };
      default = {
        enable = true;
      };
      description = "Enable the autoraise launchd service";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = [pkgs.autoraise];
    }
    (lib.mkIf cfg.service.enable {
      launchd.agents.autoraise = {
        enable = true;
        config = lib.mkMerge [
          {
            ProgramArguments = ["${pkgs.autoraise}/bin/autoraise"];
            RunAtLoad = true;
            KeepAlive = true;
            ProcessType = "Interactive";
          }
          (lib.mkIf (cfg.service.stdOutputPath != null) {
            StandardOutPath = "${cfg.service.stdOutputPath}/autoraise.stdout";
            StandardErrorPath = "${cfg.service.stdOutputPath}/autoraise.stderr";
          })
        ];
      };
    })
  ]);
}
