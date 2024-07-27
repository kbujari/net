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
  systemd.services.nginx.serviceConfig.ProtectHome = false;
  # services.nginx.virtualHosts.${cfg.settings.server.domain} = {
  services.nginx.virtualHosts."192.168.2.113" = {
    locations."/" = {
      proxyPass = "http://unix:/${socket}";
      proxyWebsockets = true;
    };
  };
}
