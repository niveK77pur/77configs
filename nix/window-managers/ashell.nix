{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.ashell;
  tomlFormat = pkgs.formats.toml {};
in {
  options.ashell = {
    enable = lib.mkEnableOption "ashell";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [(config.lib.nixGL.wrap pkgs.ashell)];
    fuzzel.enable = true;
    wezterm.enable = true;
    xdg.configFile."ashell/config.toml".source = tomlFormat.generate "ashell-config" {
      app_launcher_cmd = "fuzzel";
      clipboard_cmd = "${config.wezterm.package}/bin/wezterm start --class clipse -e clipse";
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
      settings = {
        wifi_more_cmd = "nm-connection-editor";
      };
    };
  };
}
