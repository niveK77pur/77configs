{
  pkgs,
  lib,
  config,
  wrapNixGL,
  ...
}: let
  cfg = config.ashell;
  tomlFormat = pkgs.formats.toml {};
in {
  options.ashell = {
    enable = lib.mkEnableOption "ashell";
    package = lib.mkOption {
      type = lib.types.package;
      default = wrapNixGL {
        binName = "ashell";
        inherit config;
      };
      description = "Package to use; wrap with nixGL if enabled";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
    fuzzel.enable = true;
    wezterm.enable = true;
    xdg.configFile."ashell/config.toml".source = tomlFormat.generate "ashell-config" {
      appLauncherCmd = "fuzzel";
      clipboardCmd = "${config.wezterm.package}/bin/wezterm start --class clipse -e clipse";
      modules = {
        left = [
          "AppLauncher"
          "Clipboard"
          "Workspaces"
        ];
        center = [
          # "WindowTitle"
          "Clock"
        ];
        right = [
          "Tray"
          [
            "Privacy"
            "Settings"
            "SystemInfo"
          ]
        ];
      };
    };
  };
}
