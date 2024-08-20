{ config, lib, pkgs, ... }: {
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
