{ config, lib, pkgs, ... }:
let
  fet = pkgs.fetchurl {
    url = "https://grafana.com/api/dashboards/1860/revisions/37/download";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

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
  };

  services.grafana.provision.dashboards.settings.providers = [
    {
      name = "Node Exprter Full";
      options.path = fet.outPath;
    }
  ];

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
