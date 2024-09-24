{
  lib,
  config,
  ...
}: {
  options.flameshot.enable = lib.mkEnableOption "flameshot";
  config = lib.mkIf config.flameshot.enable {
    services.flameshot.enable = true;
  };
}
