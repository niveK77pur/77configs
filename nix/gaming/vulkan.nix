{
  pkgs,
  lib,
  config,
  ...
}: {
  options.vulkan.enable = lib.mkEnableOption "vulkan";
  config = lib.mkIf config.vulkan.enable {
    home.packages = with pkgs; [vulkan-tools];
  };
}
