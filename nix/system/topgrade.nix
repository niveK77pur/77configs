{
  lib,
  config,
  ...
}: {
  options.topgrade.enable = lib.mkEnableOption "topgrade" // {default = true;};
  config = lib.mkIf config.topgrade.enable {
    programs.topgrade = {
      enable = true;
      settings = {
        misc.disable = [
          "tmux"
          "conda"
          "containers"
          "gem"
          "vim"
        ];
        git.repos = [
          "~/.config/77configs"
          "~/.config/nvim"
          "~/.password-store"
        ];
      };
    };
  };
}
