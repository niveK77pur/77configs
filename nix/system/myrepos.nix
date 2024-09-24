{
  lib,
  config,
  ...
}: {
  options.myrepos.enable = lib.mkEnableOption "myrepos";
  options.myrepos = {
    cloneMode = lib.mkOption {
      default = "ssh";
      description = "Whether or not to use SSH for cloning repositories.";
      type = lib.types.enum ["https" "ssh"];
    };
  };

  config = lib.mkIf config.myrepos.enable {
    programs.mr.enable = true;
    # settings are specfied elsewhere along their respective tools
  };
}
