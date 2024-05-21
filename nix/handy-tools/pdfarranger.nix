{pkgs, ...}: {
  config = {
    home.packages = [pkgs.pdfarranger];
  };
}
