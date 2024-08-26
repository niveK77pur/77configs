{
  lib,
  config,
  ...
}: {
  options.bat.enable = lib.mkEnableOption "bat" // {default = true;};
  config = lib.mkIf config.bat.enable {
    programs.bat.enable = true;
  };
}
