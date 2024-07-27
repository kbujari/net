{ config, lib, pkgs, ... }: {
  services.prometheus.exporters = {
    smartctl = {
            enable = true;
      devices = [ "all" ];
      smartctlArgs = "-a";
      interval = "60s";
      openFirewall = true;
      user = "root";  # Required to read all disks
    };
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      openFirewall = true;
    };
  };

  systemd.services."prometheus-smartctl-exporter".serviceConfig.DeviceAllow = lib.mkOverride 10 [
    "block-blkext rw"
    "block-sd rw"
    "char-nvme rw"
  ];

  environment.systemPackages = with pkgs; [ smartmontools ];
}
