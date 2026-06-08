{
  config,
  lib,
  ...
}: let
  cfg = config.media;
in {
  imports =
    map
    (file: ./. + "/${file}")
    (lib.filter
      (f: f != "default.nix")
      (lib.attrNames (builtins.readDir ./.)));
  options.media = {
    enableAll = lib.mkEnableOption "media";
    isServerConfiguration = lib.mkEnableOption "media server configuration" // {default = config.isServerConfiguration;};
  };

  config = lib.mkIf cfg.enableAll (lib.mkMerge [
    {
      ani-cli.enable = lib.mkDefault true;
      yt-dlp.enable = lib.mkDefault true;
    }
    (lib.mkIf (!cfg.isServerConfiguration) {
      flameshot.enable = lib.mkDefault true;
      mpv.enable = lib.mkDefault true;
      sioyek.enable = lib.mkDefault true;
      streamlink.enable = lib.mkDefault true;
      zathura.enable = lib.mkDefault true;
    })
  ]);
}
