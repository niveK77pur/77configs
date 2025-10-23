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
        "--disable-ctrl-r"
      ];
      settings = {
        update_check = false;
        filter_mode_shell_up_key_binding = "session";
      };
    };
    programs.fish = {
      functions = {
        _atuin_search_fzf = {
          body = let
            fzf_opts = [
              "--read0"

              "--height 40%"
              "--layout reverse"
              "--info inline-right"
              "--prompt 'autin > '"

              "--delimiter @"
              "--with-nth '{6..}'"
              "--accept-nth '{6..}'"

              "--preview 'echo [{5}] {2} ago in {4}; echo {6..}'"
              "--preview-window 'down,4,wrap,hidden,~1'"

              "--tiebreak index"
              "--no-multi"
              "--no-scrollbar"
              "--no-separator"

              "--bind ?:toggle-preview"
            ];
            atuin_opts = [
              "--print0"
              "--reverse"
              "--format '{time}@{relativetime}@{duration}@{directory}@{exit}@{command}'"
            ];
            fzf = lib.getExe config.programs.fzf.package;
            atuin = lib.getExe config.programs.atuin.package;
          in ''
            # TODO: save screen and restore?
            set -l selection (${atuin} search ${lib.concatStringsSep " " atuin_opts} | ${fzf} ${lib.concatStringsSep " " fzf_opts})
            if test $status -eq 0
              commandline -r -- $selection
            end
            commandline -f repaint
          '';
          description = "_atuin_search using fzf";
        };
      };
      binds."ctrl-r".command = "_atuin_search_fzf";
    };
  };
}
