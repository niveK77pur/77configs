{
  lib,
  config,
  ...
}: {
  options.gh.enable = lib.mkEnableOption "gh";
  config = lib.mkIf config.gh.enable {
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
  };
}
