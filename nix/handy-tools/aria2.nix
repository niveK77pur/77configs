{
  lib,
  config,
  ...
}: {
  options.aria2.enable = lib.mkEnableOption "aria2";
  config = lib.mkIf config.aria2.enable {
    programs.aria2 = {
      enable = true;
      settings = {
        continue = true;
        auto-file-renaming = false;
        summary-interval = 180;
      };
    };
  };
}
