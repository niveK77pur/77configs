{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.wlogout;
  #  {{{1
  fromWlogoutLayout = layoutFile:
  # Each JSON directory will be transformed so that the 'text' attribute
  # becomes the key of the attribute set. This makes it simpler to modify the
  # data in nix as opposed to using a list of attribute sets.
  # i.e:
  #      [..., { ..., text = "MyButton", ... }, ...]
  #   => { ..., "MyButton" = { ... }, ... }
    lib.lists.foldr
    (e: agg:
      agg
      // {
        "${e.text}" = builtins.removeAttrs e ["text"] // {index = builtins.length (builtins.attrNames agg);};
      })
    {}
    (
      builtins.fromJSON (
        lib.strings.concatStrings [
          "["
          (
            builtins.concatStringsSep "," (
              # retrieve the individual dict entries
              lib.lists.flatten (
                builtins.filter (e: (builtins.typeOf e) == "list") (
                  builtins.split ''(\{[^}]*})'' (
                    builtins.readFile layoutFile
                  )
                )
              )
            )
          )
          "]"
        ]
      )
    );
  #  {{{1
  toWlogLayout = layout:
    lib.strings.concatMapStrings (e: builtins.toJSON (builtins.removeAttrs e ["index"])) (
      builtins.sort (p: q: p.index < q.index) (
        builtins.attrValues (
          lib.attrsets.mapAttrs (name: value: value // {text = name;}) layout
        )
      )
    );
  #  }}}1
in {
  options.wlogout = {
    enable = lib.mkEnableOption "wlogout";
    layout = lib.mkOption {
      type = lib.types.attrs;
      default = fromWlogoutLayout "${pkgs.wlogout}/etc/wlogout/layout";
      description = "wlogout settings";
    };
    override-layout = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Override or expand existing settings";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.wlogout];
    xdg.configFile."wlogout/layout".text = toWlogLayout (lib.recursiveUpdate cfg.layout cfg.override-layout);
  };
}
# vim: fdm=marker

