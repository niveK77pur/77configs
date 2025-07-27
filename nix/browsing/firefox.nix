{
  lib,
  config,
  ...
}: let
  cfg = config.firefox;
in {
  options.firefox = {
    enable = lib.mkEnableOption "firefox";
    enableKyomeiProfile = lib.mkEnableOption "firefox";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.firefox = {
        enable = true;
        profiles.default = {};
      };
    }
    (lib.mkIf cfg.enableKyomeiProfile {
      programs.firefox.profiles.kyomei = {
        isDefault = false;
        id = 1;
        search.default = "ddg";
        #  {{{1
        settings = {
          "extensions.autoDisableScopes" = 0;
        };
        #  {{{1
        bookmarks = {
          force = true;
          settings = [
            {
              name = "Kyomei GitLab";
              tags = ["git"];
              url = "https://gitlab.com/kyomei-ai";
            }
            {
              name = "Kyomei Slack";
              tags = ["messaging"];
              url = "https://kyomei-ai.slack.com/messages";
            }
          ];
        };
        #  {{{1
        extensions = {
          packages = [
            # bitwarden
            # consent-o-matic
            # cookieblock
            # dark reader
            # foxy tab?
            # panorama tab groups?
          ];
        };
        #  }}}1
      };
    })
  ]);
}
# vim: fdm=marker

