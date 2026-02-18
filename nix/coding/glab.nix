{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.glab;
  glab-mr-fzf = pkgs.writers.writeFishBin "glab-mr-fzf" ''
    function jj-bookmark-select -a prompt query
      set -f bookmark (jj bookmark list \
        --all \
        --template 'join(":", self.name(), self.remote(), if(self.conflict(), "[conflict]", ""), if(self.synced(), "", "[out of sync]")) ++ "\n"' \
        | ${lib.getExe pkgs.fzf} \
            --prompt "$prompt> " \
            --height 10 \
            --query "$query" \
            --delimiter ':' \
            --with-nth '{1} [remote: @{2}]{3}{4}' \
            --accept-nth '{1}:{2}' \
        | string split :)
      if [ -z $bookmark[2] ]
        echo $bookmark[1]
      else
        echo $bookmark[1]@$bookmark[2]
      end
    end
    ${lib.getExe pkgs.glab} mr create -s (jj-bookmark-select source) -b (jj-bookmark-select destination "'dev | 'main")
  '';
in {
  options.glab = {
    enable = lib.mkEnableOption "glab";
    package = lib.mkPackageOption pkgs "glab" {};
    enableFishIntegration = lib.hm.shell.mkFishIntegrationOption {inherit config;};
    enableBashIntegration = lib.hm.shell.mkBashIntegrationOption {inherit config;};
    enableZshIntegration = lib.hm.shell.mkZshIntegrationOption {inherit config;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
      glab-mr-fzf
    ];

    programs = {
      fish.interactiveShellInit = lib.mkIf cfg.enableFishIntegration ''glab completion -s fish | source '';
      bash.initExtra = lib.mkIf cfg.enableBashIntegration ''source <(glab completion -s bash)'';
      zsh.initContent = lib.mkIf cfg.enableZshIntegration ''source <(glab completion -s zsh); compdef _glab glab'';
    };
  };
}
