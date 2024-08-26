{
  lib,
  config,
  ...
}: {
  options.direnv.enable = lib.mkEnableOption "direnv" // {default = true;};
  config = lib.mkIf config.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        global = {
          hide_env_diff = true;
        };
      };
    };
  };
}
