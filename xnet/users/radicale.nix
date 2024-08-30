{ config, ... }: {
  services.radicale = {
    enable = true;
    settings = {
      server.hosts = [ "127.0.0.1:5232" ];
      storage.filesystem_folder = "/persist/data/radicale/collections";
      auth = {
        type = "htpasswd";
        htpasswd_filename = "/persist/data/radicale/users";
        htpasswd_encryption = "plain";
      };
    };
  };

  services.nginx.virtualHosts."dav.web.4kb.net" = {
    useACMEHost = "4kb.net";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5232/";
    };
  };
}
