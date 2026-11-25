{lib, ...}:
lib.mkMerge [
  {
    isServerConfiguration = true;
    opencode.enable = true;
  }
]
