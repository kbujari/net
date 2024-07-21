{ config, ... }:
let
  cfg = config.services.grafana;
  addr = cfg.settings.server.http_addr;
  port = toString cfg.settings.server.http_port;
in
{
  services.grafana = {
    enable = true;
    settings.server.domain = "grafana.4kb.net";
  };

  services.nginx.virtualHosts.${cfg.settings.server.domain} = {
    locations."/" = {
      proxyPass = "http://${addr}:${port}";
      proxyWebsockets = true;
    };
  };
}
