{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.claude;
  claudeAuthEnvVar = "CLAUDE_CODE_OAUTH_TOKEN";
  #  {{{1
  bwrap-claude = pkgs.callPackage ../myscripts/derivations/bwrap-ai.nix {
    pname = "bwrap-claude";
    extraRuntimeInputs = [config.programs.claude-code.finalPackage];
    hookFile = pkgs.writeShellScript "bwrap-claude-hook" ''
      ${lib.optionalString cfg.withAuthToken ''
        # Claude Code prefers the subscription credentials file over
        # CLAUDE_CODE_OAUTH_TOKEN. Mask it so the env token is used.
        empty_creds="$(mktemp --suffix=-bwrap-claude-creds)"
        printf '{}' > "$empty_creds"
        cleanup_paths+=("$empty_creds")
      ''}

      bwrap_ai_hook_args+=(
        ${lib.optionalString cfg.withAuthToken ''--setenv ${claudeAuthEnvVar} "$(cat "${config.age.secrets.claude-auth.path}")"''}
        --rw-try "$HOME/.cache/claude-cli-nodejs"
        --rw-try "$HOME/.claude.json"
        --rw-try "$HOME/.claude"
        --ro-try "$HOME/.claude/settings.json"
        --ro-try "$HOME/.claude/settings.local.json"
        ${
        if cfg.withAuthToken
        then ''--ro-bind "$empty_creds" "$HOME/.claude/.credentials.json"''
        else ''--ro-try "$HOME/.claude/.credentials.json"''
      }
        --ro-try "$HOME/.claude/plugins"
        --ro-try "$HOME/.claude/skills"
      )

      base_command=(claude --dangerously-skip-permissions)

      [ -e "$HOME/.claude/settings.local.json" ] || touch "$HOME/.claude/settings.local.json"
    '';
  };
  #  }}}1
  claude-resume-global = pkgs.callPackage ./claude/claude-resume-global.nix {};
in {
  options.claude = {
    enable = lib.mkEnableOption "claude";
    withAuthToken = lib.mkEnableOption "claude-auth" // {default = true;};
    disableTopgrade = lib.mkEnableOption "claude-topgrade" // {default = cfg.enable;};
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = [
        bwrap-claude
        claude-resume-global
        pkgs.unixtools.script
      ];
      programs = {
        claude-code = {
          enable = true;
          inherit
            (config.programs.opencode)
            skills
            enableMcpIntegration
            ;
        };
        topgrade.settings.misc.disable = lib.optional cfg.disableTopgrade "claude_code";
      };
    }
    (lib.mkIf cfg.withAuthToken {
      programs.claude-code.package = pkgs.symlinkJoin {
        name = "claude-oauth";
        paths = [pkgs.claude-code];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/${pkgs.claude-code.meta.mainProgram} \
            --run 'token="''${${claudeAuthEnvVar}:-"$(cat "${config.age.secrets.claude-auth.path}")"}" && export ${claudeAuthEnvVar}="$token"'
        '';
      };
      age.secrets.claude-auth.file = ../../secrets/claude-auth.age;
    })
  ]);
}
# vim: fdm=marker

