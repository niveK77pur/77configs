{pkgs, ...}: {
  config = {
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
