{
  pkgs,
  lib,
  config,
  ...
}: {
  options.pdfarranger.enable = lib.mkEnableOption "pdfarranger" // {default = true;};
  config = lib.mkIf config.pdfarranger.enable {
    home.packages = [pkgs.pdfarranger];
  };
}
