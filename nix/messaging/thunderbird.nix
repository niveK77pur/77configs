{
  pkgs,
  lib,
  config,
  ...
}: {
  options.thunderbird.enable = lib.mkEnableOption "thunderbird" // {default = true;};
  config = lib.mkIf config.thunderbird.enable {
    home.packages = [pkgs.thunderbird];
  };
}
