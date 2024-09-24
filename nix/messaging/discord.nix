{
  pkgs,
  lib,
  config,
  ...
}: {
  options.discord.enable = lib.mkEnableOption "discord";
  config = lib.mkIf config.discord.enable {
    home.packages = [pkgs.discord];
  };
}
