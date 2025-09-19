{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.firefox;
in {
  options.firefox = {
    enable = lib.mkEnableOption "firefox";
    enableKyomeiProfile = lib.mkEnableOption "firefox";
    defaultProfile = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "Which profile name to set as default";
    };
    withPipewireScreenaudio = lib.mkEnableOption "pipewire-screenaudio";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.firefox = {
        enable = true;
        profiles =
          {
            default = {
              isDefault = lib.mkDefault false;
              search = {
                force = true;
                default = "ddg";
              };
            };
          }
          // {
            ${cfg.defaultProfile}.isDefault = true;
          };
      };
    }
    (lib.mkIf cfg.withPipewireScreenaudio {
      programs.firefox.package = pkgs.firefox.override {
        nativeMessagingHosts = [
          inputs.pipewire-screenaudio.packages.${pkgs.system}.default
        ];
      };
    })
    (lib.mkIf cfg.enableKyomeiProfile {
      programs.firefox.profiles.kyomei = {
        id = 1;
        search = {
          default = "ddg";
          force = true;
        };
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
            {
              name = "Community City Incubator";
              tags = ["incubator"];
              url = "https://community.cityincubator.lu/dashboard";
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

