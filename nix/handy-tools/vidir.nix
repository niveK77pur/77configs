{pkgs, ...}: {
  config = {
    home.packages = [pkgs.perl538Packages.vidir];
  };
}
