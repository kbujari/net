{ config, ... }:
let
  cfg = config.services.grafana;
  socket = toString cfg.settings.server.socket;
in
{
  services.grafana = {
    enable = true;
    settings.server.domain = "grafana.4kb.net";
    settings.server.protocol = "socket";
  };

  users.groups.grafana.members = [ "nginx" ];
  services.nginx.virtualHosts.${cfg.settings.server.domain} = {
    locations."/" = {
      proxyPass = "http://unix:/${socket}";
      proxyWebsockets = true;
    };
  };
}
