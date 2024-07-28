{ config, ... }: {
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" ];
  };

  fileSystems."/nix" = {
    device = "zroot/local/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "zroot/local/persist";
    fsType = "zfs";
  };

  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
}
