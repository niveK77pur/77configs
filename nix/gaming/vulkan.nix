{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [vulkan-tools];
  };
}
