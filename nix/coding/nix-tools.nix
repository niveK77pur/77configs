{
  pkgs,
  lib,
  config,
  system,
  ...
}: {
  options.nix-tools.enable = lib.mkEnableOption "nix-tools";
  config = lib.mkIf config.nix-tools.enable {
    home.packages = [
      pkgs.alejandra
      pkgs.nixd
      pkgs.statix
    ];
  };
}
