{ config
, pkgs
, lib
, ...
}:
let
  inherit (config.services) grafana;
  dashboardFiles = [
    ./dashboards/node-exporter-full.json
    ./dashboards/prometheus-stats.json
  ];
in
{
  services.grafana = {
    enable = true;
    settings.server.domain = "grafana.4kb.net";
    settings.server.protocol = "socket";
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://localhost:9090";
          access = "proxy";
        }
      ];
      dashboards.settings.providers = [
        {
          name = "default";
          type = "file";
          disableDeletion = true;
          updateIntervalSeconds = 10;
          options = {
            path = pkgs.runCommand "dashboards" { } ''
              mkdir -p $out
              ${lib.concatMapStrings (file: ''
                  cp ${file} $out/
                '')
                dashboardFiles}
            '';
          };
        }
      ];
    };
  };

  users.groups.grafana.members = [ "nginx" ];
  systemd.services.nginx.serviceConfig.ProtectHome = false;
  # services.nginx.virtualHosts.${cfg.settings.server.domain} = {
  services.nginx.virtualHosts."192.168.2.113" = {
    locations."/" = {
      proxyPass = "http://unix:/${toString grafana.settings.server.socket}";
      proxyWebsockets = true;
    };
  };
}
