{pkgs, ...}: {
  config = {
    home.packages = [pkgs.gamescope];
  };
}
