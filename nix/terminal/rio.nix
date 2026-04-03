{
  lib,
  config,
  ...
}: {
  options.rio.enable = lib.mkEnableOption "rio";
  config = lib.mkIf config.rio.enable {
    
    programs.rio = {
      enable = true;
      settings = {
        use-fork = true;
      };
    };
  };
}
# vim: fdm=marker

