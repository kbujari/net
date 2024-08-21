{ config, ... }: {
  services.radicale = {
    enable = true;
    settings = {
      server.hosts = [ "127.0.0.1:5232" ];
    };
  };

  services.nginx.virtualHosts."dav.4kb.net" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:5232/";
    };
  };
}
