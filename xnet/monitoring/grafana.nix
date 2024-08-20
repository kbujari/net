{ config, lib, pkgs, ... }:
let
  fet = pkgs.fetchurl { };

in
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

  networking.firewall.allowedTCPPorts = [ 3000 ];
  services.grafana = {
    enable = true;
    settings.server.domain = "grafana.4kb.net";
    settings.server.http_addr = "0.0.0.0";
    # settings.server.protocol = "socket";
    settings."auth.anonymous" = {
      enabled = true;
      org_role = "Admin";
    };
  };
}
