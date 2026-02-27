{
  lib,
  config,
  ...
}: let
  cfg = config.zoxide;
in {
  options.zoxide = {
    enable = lib.mkEnableOption "zoxide";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.programs.z-lua.enable;
        message = "z-lua should not be used together with zoxide";
      }
    ];

    programs.zoxide = {
      enable = true;
    };
  };
}
