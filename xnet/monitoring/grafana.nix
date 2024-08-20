{ config, lib, pkgs, ... }:
{
  services.grafana.provision = {
    enable = true;
    datasources.settings.datasources = [{
      name = "Prometheus";
      type = "prometheus";
      url = "http://localhost:9090";
      access = "proxy";
      editable = false;
    }];

    dashboards.settings.providers = [{
      name = "Fetched Dashboards";
      options.path = "/etc/grafana/dashboards";
    }];
  };

  environment.etc = {
    "grafana/dashboards/node-exporter.json" = {
      user = "grafana";
      group = "grafana";
      source = pkgs.fetchurl {
        url = "https://grafana.com/api/dashboards/1860/revisions/37/download";
        hash = "sha256-1DE1aaanRHHeCOMWDGdOS1wBXxOF84UXAjJzT5Ek6mM=";
      };
    };
  };

  services.grafana = {
    enable = true;
    settings.server.domain = "grafana.4kb.net";
    settings.server.protocol = "socket";
    settings."auth.anonymous" = {
      enabled = true;
      org_role = "Admin";
    };
  };

  users.groups.grafana.members = [ "nginx" ];
  systemd.services.nginx.serviceConfig.ProtectHome = false;

  services.nginx.virtualHosts."${config.services.grafana.settings.server.domain}" = {
    addSSL = true;
    useACMEHost = "4kb.net";
    locations."/" = {
      proxyPass = "http://unix:/${toString config.services.grafana.settings.server.socket}";
      proxyWebsockets = true;
    };
  };
}
