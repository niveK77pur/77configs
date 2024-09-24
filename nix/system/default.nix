{
  config,
  lib,
  ...
}: {
  imports = [
    ./topgrade.nix
    ./pass.nix
    ./myrepos.nix
  ];

  options.system.enableAll = lib.mkEnableOption "system";

  config = lib.mkIf config.system.enableAll {
    topgrade.enable = lib.mkDefault true;
    pass.enable = lib.mkDefault true;
    myrepos.enable = lib.mkDefault true;
  };
}
