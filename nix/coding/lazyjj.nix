{
  lib,
  config,
  pkgs,
  helper,
  ...
}: let
  cfg = config.lazyjj;
in {
  options.lazyjj = {
    enable = lib.mkEnableOption "lazyjj";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.lazyjj];
    programs.fish.functions = {
      lj = helper.makeFishAliasFunction {
        body = "lazyjj $argv";
      };
    };
  };
}
