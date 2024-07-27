{ config, pkgs, lib, ... }:
let
  inherit (config.services) grafana;
  dashboards = {
    "node-exporter-full" = {
      id = 1860;
      revision = 37;
    };
    "prometheus-stats" = {
      id = 3662;
      revision = 2;
    };
  };
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
          path = pkgs.writeTextDir "dashboards" (
            lib.concatStringsSep "\n" (
              lib.mapAttrsToList
                (name: dashboard:
                  builtins.toFile "${name}.json" (builtins.toJSON {
                    annotations.list = [ ];
                    editable = true;
                    gnetId = dashboard.id;
                    graphTooltip = 0;
                    id = null;
                    links = [ ];
                    panels = [ ];
                    schemaVersion = 16;
                    style = "dark";
                    tags = [ ];
                    templating.list = [ ];
                    time = {
                      from = "now-6h";
                      to = "now";
                    };
                    timepicker = { };
                    timezone = "browser";
                    title = name;
                    uid = name;
                    version = dashboard.revision;
                  })
                )
                dashboards
            )
          );
        };
      }];
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
