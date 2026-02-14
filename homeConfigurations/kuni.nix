{
  pkgs,
  lib,
  git,
  stylix-base16Scheme,
}: [
  {
    config = {
      home.packages = [
        pkgs.bitwarden-desktop
      ];
      claude.enable = true;
      opencode.enable = true;
      services.ssh-agent.enable = true;
      firefox = {
        enableKyomeiProfile = true;
        defaultProfile = "kyomei";
      };
      slack.enable = true;
      gcloud.enable = true;
      glab.enable = true;
      keychain.enable = true;
      categories.enableAll = true;
      gaming.enableAll = false;
      home.withNixGL = rec {
        enable = true;
        package = pkgs.nixgl.nixGLIntel;
        command = "${package}/bin/nixGLIntel";
      };
      wezterm.overrides = {
        font_size = 9.5;
      };
      zathura.withLilypondXdgOpen = true;
      git = {inherit (git) userName userEmail;};
      jj = {
        inherit (git) userName userEmail;
      };
      mrandr = {
        SCREEN = "eDP";
        OUTPUT = "DisplayPort-0";
      };
      swww.service = {
        enable = true;
        imagesDir = "/home/kuni/Pictures/i3wallpapers/active";
      };
      sx.base16Scheme = stylix-base16Scheme;
      hyprland = {
        enable = true;
        monitor = [
          {
            name = "eDP-1";
            scale = 1.6;
          }
          {
            name = "DP-1"; # TODO: Make sure it matches monitor by name and ID
            position = "auto-left";
            scale = 1 + 1.0 / 3;
          }
          {
            name = "HDMI-A-1";
            position = "auto-up";
          }
          {
            # monitor on dongle
            name = "desc:LG Electronics LG ULTRAFINE 0x00015B5D";
            position = "auto-right";
            scale = 1.6;
          }
          {
            # monitor on HDMI
            name = "desc:LG Electronics LG ULTRAFINE 502NTKF2L925";
            position = "auto-right";
            scale = 1.6;
          }
        ];
      };
      programs.hyprlock.package = null; # nixpkgs hyprlock does not respect Fedora PAM config
    };
  }
  {
    programs.television = {
      enable = true;
      channels = let
        bao = lib.getExe pkgs.openbao;
        jq = lib.getExe pkgs.jq;
      in {
        bao-approle = {
          metadata = {
            name = "bao approle";
            description = "View bao approle roles";
          };
          source.command = "${bao} list -format=json auth/approle/role | ${jq} --raw-output '.[]'";
          preview.command = "${bao} read auth/approle/role/{}";
        };
        bao-policy = {
          metadata = {
            name = "bao policy";
            description = "View bao policies";
          };
          source.command = "${bao} policy list -format=json | ${jq} --raw-output '.[]'";
          preview.command = "${bao} policy read {}";
        };
      };
    };
  }
]
