{pkgs, ...}: {
  config = {
    home.packages = [pkgs.ferdium];
  };
}
