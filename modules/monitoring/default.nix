{ config, lib, pkgs, ... }: {
  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "processes" "systemd" ];
      openFirewall = true;
    };

    systemd = {
      enable = true;
      extraFlags = [
        "--systemd.collector.enable-ip-accounting"
        "--systemd.collector.enable-restart-count"
      ];
    };
  };
}
