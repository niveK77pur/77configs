{...}: {
  config = {
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
