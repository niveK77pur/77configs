{
  lib,
  pkgs,
  git,
  ...
}:
# Configuration for darwin
lib.mkMerge [
  {
    coding.enableAll = true;
    handy-tools.enableAll = true;
    kdeconnect.enable = false;
    fish.enable = true;
    ghostty.enable = true;
    programs.ghostty = {
      package = lib.mkForce null;
      systemd.enable = false;
    };
    starship.enable = true;
    git = {inherit (git) userName userEmail;};
    jj = {inherit (git) userName userEmail;};
    autoraise.enable = pkgs.stdenv.isDarwin;
  }
]
