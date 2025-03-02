{
  lib,
  config,
  ...
}: {
  options.pay-respects.enable = lib.mkEnableOption "pay-respects";
  config = lib.mkIf config.pay-respects.enable {
    programs.pay-respects.enable = true;
  };
}
