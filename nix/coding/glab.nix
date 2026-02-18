{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.glab;
  glab-mr-fzf = pkgs.writers.writeFishBin "glab-mr-fzf" ''
    function jj-bookmark-select -a prompt
      set -f bookmark (jj bookmark list \
        --all \
        --template 'join(":", self.name(), self.remote(), if(self.conflict(), "[conflict]", ""), if(self.synced(), "", "[out of sync]")) ++ "\n"' \
        | ${lib.getExe pkgs.fzf} \
            --prompt "$prompt> " \
            --height 10 \
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
    ${lib.getExe pkgs.glab} mr create -s (jj-bookmark-select source) -b (jj-bookmark-select destination)
  '';
in {
  options.glab = {
    enable = lib.mkEnableOption "glab";
    package = lib.mkPackageOption pkgs "glab" {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
      glab-mr-fzf
    ];
  };
}
