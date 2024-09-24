{
  pkgs,
  lib,
  config,
  ...
}: {
  options.pdfarranger.enable = lib.mkEnableOption "pdfarranger";
  config = lib.mkIf config.pdfarranger.enable {
    home.packages = [pkgs.pdfarranger];
  };
}
