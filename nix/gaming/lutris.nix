{
  pkgs,
  lib,
  config,
  ...
}: {
  options.lutris.enable = lib.mkEnableOption "lutris";
  config = lib.mkIf config.lutris.enable {
    home.packages = with pkgs; [
      (lutris.override {
        extraLibraries = pkgs: [
          wineWowPackages.stable
          wineWowPackages.staging
          winetricks
          keyutils
          mangohud
        ];
      })
    ];
  };
}
