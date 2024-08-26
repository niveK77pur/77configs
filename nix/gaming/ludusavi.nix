{
  pkgs,
  lib,
  config,
  ...
}: {
  options.ludusavi.enable = lib.mkEnableOption "ludusavi" // {default = true;};
  config = lib.mkIf config.ludusavi.enable {
    home.packages = with pkgs; [ludusavi];
  };
}
