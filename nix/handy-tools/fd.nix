{
  pkgs,
  lib,
  config,
  ...
}: {
  options.fd.enable = lib.mkEnableOption "fd";
  config = lib.mkIf config.fd.enable {
    programs.fd.enable = true;
  };
}
