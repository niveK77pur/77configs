{lib, ...}: {
  options.myrepos = {
    cloneMode = lib.mkOption {
      default = "ssh";
      description = "Whether or not to use SSH for cloning repositories.";
      type = lib.types.enum ["https" "ssh"];
    };
  };

  config = {
    programs.mr.enable = true;
    # settings are specfied elsewhere along their respective tools
  };
}
