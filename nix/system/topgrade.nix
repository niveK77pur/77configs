{...}: {
  config = {
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
