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
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = [cfg.package];
    }
    (lib.mkIf cfg.service.enable (let
      imagesDir = assert cfg.service.imagesDir != null;
      assert builtins.pathExists cfg.service.imagesDir;
        cfg.service.imagesDir;
    in {
      systemd.user.timers.swww-service = {
        Unit.Description = "Run swww to update wallpaper";
        Install.WantedBy = ["timers.target"];
        Timer = {
          OnCalendar = "hourly";
          Unit = "swww-service.service";
        };
      };

      systemd.user.services.swww-service = {
        Install.WantedBy = ["default.target"];
        Unit.Description = "Periodically change wallpaper";
        Service = {
          Type = "simple";
          ExecStart = builtins.toString (pkgs.writeShellScript "swww-set-image.sh" ''
            [ -d "${imagesDir}" ] || { echo "Folder `${imagesDir}` does not exist. Exiting."; exit 255; }
            ${cfg.package}/bin/swww img \
              --transition-fps ${builtins.toString cfg.service.fps} \
              --transition-type any \
              "$(find ${imagesDir} -follow -type f | shuf -n 1)"
          '');
        };
      };
    }))
  ]);
}
