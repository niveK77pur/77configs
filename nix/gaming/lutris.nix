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
          wineWow64Packages.stable
          wineWow64Packages.staging
          winetricks
          keyutils
          mangohud
        ];
      })
    ];
  };
}
