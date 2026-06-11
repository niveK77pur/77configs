{lib, ...}:
lib.mkMerge [
  {
    isServerConfiguration = true;
    claude.enable = true;
  }
]
