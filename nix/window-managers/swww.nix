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
      home.packages = [cfg.package];
    }
    (lib.mkIf cfg.service.enable (let
      imagesDir =
        if cfg.service.assertDirExists
        then
          assert lib.assertMsg (cfg.service.imagesDir != null) "swww.service.imagesDir must be provided if swww.service.enable is enabled";
          assert lib.assertMsg (builtins.pathExists cfg.service.imagesDir) "Either path does not exist, or evaluation needs to be --impure";
            cfg.service.imagesDir
        else cfg.service.imagesDir;
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
