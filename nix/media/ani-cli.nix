{
  pkgs,
  lib,
  config,
  ...
}: {
  options.ani-cli.enable = lib.mkEnableOption "ani-cli";
  config = lib.mkIf config.ani-cli.enable {
    home.packages = with pkgs; [
      ani-cli
    ];
  };
}
