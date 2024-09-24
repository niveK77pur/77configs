{
  lib,
  config,
  ...
}: {
  options.z-lua.enable = lib.mkEnableOption "z-lua";
  config = lib.mkIf config.z-lua.enable {
    # TODO: replace with 'zoxide'?
    programs.z-lua = {
      enable = true;
      enableAliases = true;
    };
  };
}
