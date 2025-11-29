{
  config,
  lib,
  ...
}: {
  imports =
    map
    (file: ./. + "/${file}")
    (lib.filter
      (f: f != "default.nix")
      (lib.attrNames (builtins.readDir ./.)));

  options.media.enableAll = lib.mkEnableOption "media";

  config = lib.mkIf config.media.enableAll {
    ani-cli.enable = lib.mkDefault true;
    mpv.enable = lib.mkDefault true;
    yt-dlp.enable = lib.mkDefault true;
    zathura.enable = lib.mkDefault true;
    flameshot.enable = lib.mkDefault true;
    streamlink.enable = lib.mkDefault true;
  };
}
