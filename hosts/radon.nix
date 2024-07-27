{ config, modulesPath, lib, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../modules/boot

    ../modules/users
    ../modules/sshd

    ../modules/monitoring
    ../modules/monitoring/grafana.nix
    ../modules/monitoring/prometheus.nix

    ../modules/nginx.nix
  ];

  # redundant efi system partitions
  boot.swraid = {
    enable = true;
    mdadmConf = ''
      ARRAY /dev/md/esp metadata=1.0 UUID=50131eb1:c81d075b:343e0ea3:bf90c8d1
    '';
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/64B3-2F12";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  networking.hostName = "radon";
  networking.hostId = "71023948";

  system.stateVersion = "24.11";
}
