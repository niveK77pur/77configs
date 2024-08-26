{
  pkgs,
  lib,
  config,
  alejandra,
  system,
  ...
}: {
  options.nix-tools.enable = lib.mkEnableOption "nix-tools" // {default = true;};
  config = lib.mkIf config.nix-tools.enable {
    home.packages = [
      alejandra.defaultPackage.${system}
      pkgs.nixd
      pkgs.statix
    ];
  };
}
