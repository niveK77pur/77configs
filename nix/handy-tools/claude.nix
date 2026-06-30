{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.claude;
  claudeAuthEnvVar = "CLAUDE_CODE_OAUTH_TOKEN";
  #  {{{1
  bwrap-claude = pkgs.writeShellApplication {
    # Written on fedora, test on other distros
    name = "bwrap-claude";
    runtimeInputs = [
      pkgs.bubblewrap
      pkgs.coreutils
      config.programs.claude-code.finalPackage
    ];
    text = ''
      bwrap_extra=()
      # everything before a '--' goes to bwrap
      # everything after goes to the command
      while [[ $# -gt 0 ]]; do
        case "$1" in
          --ro) bwrap_extra+=(--ro-bind "$(realpath "$2")" "$(realpath "$2")"); shift 2;;
          --rw) bwrap_extra+=(--bind "$(realpath "$2")" "$(realpath "$2")"); shift 2;;
          --ro-try) bwrap_extra+=(--ro-bind-try "$(realpath -m "$2")" "$(realpath -m "$2")"); shift 2;;
          --rw-try) bwrap_extra+=(--bind-try "$(realpath -m "$2")" "$(realpath -m "$2")"); shift 2;;
          --) shift; break;;
          *) bwrap_extra+=("$1"); shift;;
        esac
      done

      # shellcheck disable=SC1091
      distro=$(. /etc/os-release && echo "$ID")
      case "$distro" in
        # Networking needs the distro's DNS/NSS sockets plus some files under
        # /etc. Mounting the entire /run may leak too much sensitive
        # information.
        nixos) sys_paths=(/usr /bin /lib /lib64 /run/nscd /run/current-system /run/wrappers) ;;
        fedora) sys_paths=(/usr /bin /lib /lib64 /run/systemd/resolve) ;;
        *) echo "bwrap-claude: unsupported distro '$distro'" >&2; exit 1 ;;
      esac
      sys_binds=()
      for d in "''${sys_paths[@]}"; do
        sys_binds+=(--ro-bind "$d" "$d")
      done

      bwrap_args=(
        --die-with-parent

        # Obfuscate some information inside the sandbox to prevent accidental
        # leaking and mingling with the host system.
        --unshare-pid
        --unshare-uts
        --unshare-ipc

        # Detaches the process from the terminal, preventing any TIOCSTI
        # attacks; injecting characters into the parent terminal and executing
        # unintended commands on the host.
        --new-session

        # Provide access to applications and files installed on the system,
        # otherwise the sandbox will be severely lacking in capabilities.
        --ro-bind /nix /nix
        --ro-bind /etc /etc

        # This may contain sensitive information which we explicitly prevent
        # from being bound into the sandbox. This is a "catch-all" in case more
        # of "/run" is mounted.
        # WARN: We may want to put this argument at the very end.
        --tmpfs /run/user

        --dev /dev
        --proc /proc

        ${lib.optionalString cfg.withAuthToken ''--setenv ${claudeAuthEnvVar} "$(cat "${config.age.secrets.claude-auth.path}")"''}

        # Explicitly prevent writing into these folders, to avoid giving the
        # wrong impression. By default, folders will be a writable tmpfs within
        # the sandbox.
        --perms 550 --tmpfs /home
        --perms 550 --tmpfs "$HOME"

        # Mount a proper folder into the sandbox /tmp if needed
        --tmpfs /tmp

        # Make life a bit easier and allow tools and everything to continue
        # working with their states. Do not allow modifying them though.
        --ro-bind "$HOME/.nix-profile" "$HOME/.nix-profile"
        --ro-bind "$HOME/.config" "$HOME/.config"
        --ro-bind "$HOME/.local" "$HOME/.local"
        --ro-bind "$HOME/.cache" "$HOME/.cache"

        # Allow neovim in the sandbox to write into necessary locations without
        # leaking into the host.
        --tmpfs "$HOME/.local/state/nvim"
        --tmpfs "$HOME/.cache/nvim"

        # In case some of the MCP servers require uvx. This would lead to
        # redownloading everything due to not being persisted on the host.
        --tmpfs "$HOME/.cache/uv"
        --tmpfs "$HOME/.local/share/uv"

        # We can let claude manage some of its own files; being too restrictive
        # here may make claude hang on start-up. Some of these files are
        # necessary to read so that claude does not suffer a "factory reset"
        # within the sandbox. Other permissions are locked down to reduce risk
        # of malicious code injection.
        --bind-try "$HOME/.cache/claude-cli-nodejs" "$HOME/.cache/claude-cli-nodejs"
        --bind-try "$HOME/.claude.json" "$HOME/.claude.json"
        --bind-try "$HOME/.claude" "$HOME/.claude"
        --ro-bind-try "$HOME/.claude/settings.json" "$HOME/.claude/settings.json"
        --ro-bind-try "$HOME/.claude/settings.local.json" "$HOME/.claude/settings.local.json"
        --ro-bind-try "$HOME/.claude/.credentials.json" "$HOME/.claude/.credentials.json"
        --ro-bind-try "$HOME/.claude/plugins" "$HOME/.claude/plugins"
        --ro-bind-try "$HOME/.claude/skills" "$HOME/.claude/skills"

        --bind "$(pwd)" "$(pwd)"
      )
      # Create empty file on the host to ro-bind into sandbox. Otherwise, this
      # may allow code injection.
      [ -e "$HOME/.claude/settings.local.json" ] || touch "$HOME/.claude/settings.local.json"
      bwrap "''${sys_binds[@]}" "''${bwrap_args[@]}" "''${bwrap_extra[@]}" -- claude --dangerously-skip-permissions "$@"
    '';
  };
  #  }}}1
in {
  options.claude = {
    enable = lib.mkEnableOption "claude";
    withAuthToken = lib.mkEnableOption "claude-auth" // {default = true;};
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = lib.singleton bwrap-claude;
      programs.claude-code = {
        enable = true;
        inherit
          (config.programs.opencode)
          skills
          enableMcpIntegration
          ;
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

