{ config, pkgs, lib, ... }:
let
  inherit (config.services) grafana;
  dashboards = [
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
      datasources.settings.datasources = [{
        name = "Prometheus";
        type = "prometheus";
        url = "http://localhost:9090";
        access = "proxy";
      }];
      dashboards.settings.providers = [{
        name = "default";
        type = "file";
        disableDeletion = true;
        updateIntervalSeconds = 10;
        options = {
          path = pkgs.runCommand "dashboards" { } ''
            mkdir -p $out
            ${lib.concatMapStrings (file: "cp ${file} $out/") dashboards }
          '';
        };
      }];
    };
  };

  # give nginx access to read the grafana socket
  users.groups.grafana.members = [ "nginx" ];
  systemd.services.nginx.serviceConfig.ProtectHome = false;

  services.nginx.virtualHosts."${grafana.settings.server.domain}" = {
    addSSL = true;
    useACMEHost = "4kb.net";
    locations."/" = {
      proxyPass = "http://unix:/${toString grafana.settings.server.socket}";
      proxyWebsockets = true;
    };
  };
}
