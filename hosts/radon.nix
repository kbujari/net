{ config, ... }: {
  system.stateVersion = "24.05";

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

  boot.zfs.extraPools = [ "radon" ];
  networking.firewall.allowedTCPPorts = [ 2049 ];
  services.nfs.server = {
    enable = true;
  };

  networking = {
    hostName = "radon";
    hostId = "71023948";
    vlans = {
      vlan4 = {
        id = 4;
        interface = "enp2s0";
      };
    };
    interfaces.vlan4.ipv4.addresses = [
      {
        address = "10.54.4.1";
        prefixLength = 24;
      }
    ];
  };

  imports = [
    ../modules/boot

    ../modules/users
    ../modules/sshd

    ../modules/monitoring
    ../modules/monitoring/grafana.nix
    ../modules/monitoring/prometheus.nix

    ../modules/base.nix
    ../modules/nginx.nix
  ];
}
