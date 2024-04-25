{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [glxinfo];
  };
}
