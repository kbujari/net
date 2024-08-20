{ config, lib, pkgs, ... }:
let
  fet = pkgs.fetchurl {
    url = "https://grafana.com/api/dashboards/1860/revisions/37/download";
    hash = "sha256-1DE1aaanRHHeCOMWDGdOS1wBXxOF84UXAjJzT5Ek6mM=";
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

    dashboards.settings.providers = [{
      name = "Fetched Dashboards";
      type = "file";
      disableDeletion = true;
      updateIntervalSeconds = 3600; # Optional: update every hour
      options = {
        path = pkgs.symlinkJoin {
          name = "grafana-dashboards";
          paths = [
            (pkgs.fetchurl {
              name = "node-exporter-dashboard.json";
              url = "https://grafana.com/api/dashboards/1860/revisions/27/download";
              sha256 = "0s3wmxw66xc8bvg28q2g2swklfj7n1q2ngbqbrx86w859w3jkimc";
            })
            (pkgs.fetchurl {
              name = "systemd-dashboard.json";
              url = "https://grafana.com/api/dashboards/13474/revisions/1/download";
              sha256 = "1z1fvxqgp47gqx7s76ajlf4hc0mxqcm2npidkwd1gqy2s3ys1v9k";
            })
            (pkgs.fetchurl {
              name = "prometheus-2-0-overview.json";
              url = "https://grafana.com/api/dashboards/11074/revisions/9/download";
              sha256 = "1h6n2gj0j0p3z1lmdvc33wplg5a0wb4n0q39mvawy3fqi4pmsbqq";
            })
          ];
        };
      };
    }];
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
