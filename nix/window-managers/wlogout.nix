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
    (e: agg: agg // {"${e.text}" = builtins.removeAttrs e ["text"];})
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
  #  }}}1
in {
  options.wlogout = {
    enable = lib.mkEnableOption "wlogout";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.wlogout];
  };
}
# vim: fdm=marker

