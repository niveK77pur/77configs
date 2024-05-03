{pkgs, ...}: {
  config = {
    home.packages = [pkgs.discord];
  };
}
