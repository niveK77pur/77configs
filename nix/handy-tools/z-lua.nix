{
  lib,
  config,
  ...
}: {
  options.z-lua.enable = lib.mkEnableOption "z-lua";
  config = lib.mkIf config.z-lua.enable {
    programs.z-lua = {
      enable = true;
      enableAliases = true;
    };
  };
}
