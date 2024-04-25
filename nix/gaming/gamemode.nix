{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [gamemode];
  };
}
