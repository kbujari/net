{ config, ... }: {
  services.jellyfin = {
    enable = true;
  };

  services.nginx.virtualHosts."mov.web.4kb.net" = {
    locations."/" = {
      proxyPass = "http://localhost:8096/";
    };
  };
}
