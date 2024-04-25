{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [lutris];
  };
}
