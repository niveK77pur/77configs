{
  lib,
  config,
  ...
}: {
  options.atuin.enable = lib.mkEnableOption "atuin";
  config = lib.mkIf config.atuin.enable {
    programs.atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
      ];
      settings = {
        update_check = false;
        filter_mode_shell_up_key_binding = "session";
      };
    };
  };
}
