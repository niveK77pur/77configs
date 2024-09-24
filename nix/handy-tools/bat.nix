{
  lib,
  config,
  ...
}: {
  options.bat.enable = lib.mkEnableOption "bat";
  config = lib.mkIf config.bat.enable {
    programs.bat.enable = true;
  };
}
