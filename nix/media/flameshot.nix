{
  lib,
  config,
  ...
}: {
  options.flameshot.enable = lib.mkEnableOption "flameshot" // {default = true;};
  config = lib.mkIf config.flameshot.enable {
    services.flameshot.enable = true;
  };
}
