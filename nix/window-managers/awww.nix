{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.awww;
in {
  options.awww = {
    enable = lib.mkEnableOption "awww";

    service = {
      enable = lib.mkEnableOption "awww-service";
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
        lib.mkEnableOption "awww-service-assert"
        // {
          description = "Assert that `awww.service.imagesDir` path exists and fail evaluation if not";
        };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.service.enable -> cfg.service.imagesDir != null;
          message = "awww.service.imagesDir must be provided if awww.service.enable is enabled";
        }
        {
          assertion = cfg.service.assertDirExists -> (builtins.pathExists cfg.service.imagesDir);
          message = "Either path does not exist, or evaluation needs to be --impure";
        }
      ];

      services.awww.enable = true;
    }
    (lib.mkIf cfg.service.enable {
      systemd.user.timers.awww-service = {
        Unit.Description = "Run awww to update wallpaper";
        Install.WantedBy = ["timers.target"];
        Timer = {
          OnCalendar = "hourly";
          Persistent = true;
          Unit = "awww-service.service";
        };
      };

      systemd.user.services.awww-service = {
        Install.WantedBy = ["default.target"];
        Unit.Description = "Periodically change wallpaper";
        Service = {
          Type = "simple";
          ExecStart = toString (pkgs.writeShellScript "awww-set-image.sh" ''
            [ -d "${cfg.service.imagesDir}" ] || { echo "Folder `${cfg.service.imagesDir}` does not exist. Exiting."; exit 255; }
            ${lib.getExe config.services.awww.package} img \
              --transition-fps ${toString cfg.service.fps} \
              --transition-type random \
              "$(find ${cfg.service.imagesDir} -follow -type f | shuf -n 1)"
          '');
        };
      };
    })
  ]);
}
