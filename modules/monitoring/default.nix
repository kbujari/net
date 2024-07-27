{ config,lib, pkgs, ... }: {
  services.prometheus.exporters = {
    smartctl = {
      enable = true;
    };
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
    };
  };

  systemd.services."prometheus-smartctl-exporter".serviceConfig.DeviceAllow = lib.mkOverride 10 [
    "block-blkext rw"
    "block-sd rw"
    "char-nvme rw"
  ];

  environment.systemPackages = with pkgs; [ smartmontools ];
}
