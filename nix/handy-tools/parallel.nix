{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.parallel;
in {
  options.parallel = {
    enable = lib.mkEnableOption "parallel";
    enableBashIntegration = lib.hm.shell.mkBashIntegrationOption {inherit config;};
    enableZshIntegration = lib.hm.shell.mkZshIntegrationOption {inherit config;};
  };

  config = lib.mkIf config.parallel.enable {
    home.packages = [pkgs.parallel];
    programs = {
      bash.initExtra = lib.mkIf cfg.enableBashIntegration ''eval "$(parallel --shell-completion bash)"'';
      zsh.initContent = lib.mkIf cfg.enableZshIntegration ''eval "$(parallel --shell-completion zsh)"'';
    };
  };
}
