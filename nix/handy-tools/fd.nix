{
  pkgs,
  lib,
  config,
  ...
}: {
  options.fd.enable = lib.mkEnableOption "fd" // {default = true;};
  config = lib.mkIf config.fd.enable {
    programs.fd.enable = true;
  };
}
