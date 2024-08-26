{
  pkgs,
  lib,
  config,
  ...
}: {
  options.vulkan.enable = lib.mkEnableOption "vulkan" // {default = true;};
  config = lib.mkIf config.vulkan.enable {
    home.packages = with pkgs; [vulkan-tools];
  };
}
