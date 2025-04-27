{
  pkgs,
  lib,
  config,
  system,
  swww,
  ...
}: let
  cfg = config.swww;
in {
  options.swww = {
    enable = lib.mkEnableOption "swww";
    package = lib.mkOption {
      type = lib.types.package;
      default = swww.packages.${system}.swww;
      description = "swww package to use";
    };

    service = {
      enable = lib.mkEnableOption "swww-service";
      fps = lib.mkOption {
        type = lib.types.number;
        default = 265;
        description = "Framerate for animation";
      };
      imagesDir = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to folder containing images";
      };
      assertDirExists =
        lib.mkEnableOption "swww-service-assert"
        // {
          description = "Assert that `swww.service.imagesDir` path exists and fail evaluation if not";
        };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.service.enable -> cfg.service.imagesDir != null;
          message = "swww.service.imagesDir must be provided if swww.service.enable is enabled";
        }
        {
          assertion = cfg.service.assertDirExists -> (builtins.pathExists cfg.service.imagesDir);
          message = "Either path does not exist, or evaluation needs to be --impure";
        }
      ];

      home.packages = [cfg.package];
    }
    (lib.mkIf cfg.service.enable {
      systemd.user.timers.swww-service = {
        Unit.Description = "Run swww to update wallpaper";
        Install.WantedBy = ["timers.target"];
        Timer = {
          OnCalendar = "hourly";
          Persistent = true;
          Unit = "swww-service.service";
        };
      };

      systemd.user.services.swww-service = {
        Install.WantedBy = ["default.target"];
        Unit.Description = "Periodically change wallpaper";
        Service = {
          Type = "simple";
          ExecStart = builtins.toString (pkgs.writeShellScript "swww-set-image.sh" ''
            [ -d "${cfg.service.imagesDir}" ] || { echo "Folder `${cfg.service.imagesDir}` does not exist. Exiting."; exit 255; }
            ${cfg.package}/bin/swww img \
              --transition-fps ${builtins.toString cfg.service.fps} \
              --transition-type any \
              "$(find ${cfg.service.imagesDir} -follow -type f | shuf -n 1)"
          '');
        };
      };
    })
  ]);
}
