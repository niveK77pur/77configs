{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hours;
  module = {
    lib,
    buildGoModule,
    fetchFromGitHub,
  }:
    buildGoModule rec {
      pname = "hours";
      version = "0.5.0";

      src = fetchFromGitHub {
        owner = "dhth";
        repo = "hours";
        tag = "v${version}";
        sha256 = "sha256-B9M02THTCrr7ylbbflpkpTFMuoIwV2O0PQKOKbyxYPg=";
      };

      vendorHash = "sha256-5lhn0iTLmXUsaedvtyaL3qWLosmQaQVq5StMDl7pXXI=";

      meta = with lib; {
        description = "A no-frills time tracking toolkit for command line nerds";
        homepage = "https://tools.dhruvs.space/hours/";
        license = licenses.mit;
      };
    };
in {
  options.hours = {
    enable = lib.mkEnableOption "hours";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage module {};
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
