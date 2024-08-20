{ config, lib, ... }:
{
  imports = [ ./grafana.nix ./prometheus.nix ];
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "processes" "systemd" ];
  };

  services.prometheus.exporters.systemd = {
    enable = true;
    extraFlags = [
      "--systemd.collector.enable-ip-accounting"
      "--systemd.collector.enable-restart-count"
    ];
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "node";
      static_configs = [{
        targets = [ "${config.networking.hostName}:${toString config.services.prometheus.exporters.node.port}" ];
      }];
    }
    {
      job_name = "systemd";
      static_configs = [{
        targets = [ "localhost:${toString config.services.prometheus.exporters.systemd.port}" ];
      }];
    }
  ];
}
