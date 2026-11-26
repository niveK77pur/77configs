{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.opencode;
  bwrap-opencode = pkgs.callPackage ../myscripts/derivations/bwrap-ai.nix {
    pname = "bwrap-opencode";
    extraRuntimeInputs = [config.programs.opencode.package];
    hookFile = pkgs.writeShellScript "bwrap-opencode-hook" ''
      bwrap_ai_hook_args+=(
        --shared-dest /tmp/opencode
        --rw "$HOME/.local/share/opencode"
        --rw "$HOME/.local/state/opencode"
      )
      base_command=(opencode --standalone --auto)
    '';
  };
  jujutsu-skill = pkgs.fetchFromGitHub {
    owner = "danverbraganza";
    repo = "jujutsu-skill";
    rev = "85a8376a3a0d5cf16ecb9b0fb0f3f48a48ce62c2";
    hash = "sha256-+6xM0G/o9qHLdDogFAWI96t3lYK5h26iXyN/IPU1xC0=";
  };
  ai-skills = pkgs.fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = "abeeaf95660ba9e8b7c753eb38f441ca707a8823";
    hash = "sha256-fc5+qmchp1IQ/rQP1olWKC1eC4VdYhaB7YYzC3+JBe0=";
  };
  mkPerms = {
    allow ? [],
    ask ? [],
    deny ? [],
    granular ? {},
  }:
    lib.mergeAttrsList (lib.flatten [
      (map (key: {${key} = "allow";}) allow)
      (map (key: {${key} = "ask";}) ask)
      (map (key: {${key} = "deny";}) deny)
      granular
    ]);
  commands = mkPerms {
    allow = [
      "curl *"
      "find *"
      "git diff *"
      "git log *"
      "git show *"
      "git status *"
      "go mod tidy"
      "go build *"
      "grep *"
      "rg *"
      "head *"
      "jj show *"
      "jj diff *"
      "jj log *"
      "ls *"
      "fd *"
      "find *"
      "tail *"
      "just lint *"
      "just typecheck *"
    ];
  };
in {
  options.opencode = {
    enable = lib.mkEnableOption "opencode";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [bwrap-opencode];
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      context = ../../config/opencode/AGENTS.md;
      skills = {
        jujutsu = "${jujutsu-skill}/jujutsu";
        handoff = "${ai-skills}/skills/productivity/handoff";
        write-a-skill = "${ai-skills}/skills/productivity/writing-for-agents";
        grill-with-docs = "${ai-skills}/skills/engineering/grill-with-docs";
        prototype = "${ai-skills}/skills/engineering/prototype";
        no-slop-prose = ../../config/opencode/skills/no-slop-prose;
      };
      settings = {
        permission = mkPerms {
          ask = ["*"];
          allow = [
            "glob"
            "grep"
            "list"
            "lsp"
            "read"
            "skill"
            "task"
            "todoread"
            "todowrite"
            "webfetch"
            "websearch"
          ];
          granular = {
            fish = commands;
            bash = commands;
          };
        };
        formatter = {
          nixfmt = {
            disabled = true;
          };
          alejandra = {
            command = ["alejandra" "$FILE"];
            extensions = [".nix"];
          };
        };
        plugin = [
          "@franlol/opencode-md-table-formatter@latest"
        ];
      };
    };
  };
}
