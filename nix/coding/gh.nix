{
  lib,
  config,
  ...
}: {
  options.gh.enable = lib.mkEnableOption "gh" // {default = true;};
  config = lib.mkIf config.gh.enable {
    programs.gh = {
      enable = true;
      # settings = {
      #   git_protocl = "ssh";
      # };
    };
  };
}
