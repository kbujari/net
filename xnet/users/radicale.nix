{ config, ... }:
let path = "/persist/data/radicale"; in {
  services.radicale = {
    enable = false;
    settings = {
      server.hosts = [ "127.0.0.1:5232" ];
      storage.filesystem_folder = "${path}/collections";
      auth = {
        type = "htpasswd";
        htpasswd_filename = "${path}/users";
        htpasswd_encryption = "plain";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d ${path} 0700 radicale radicale -"
    "Z ${path} 0700 radicale radicale - -"
  ];

  services.nginx.virtualHosts."dav.web.4kb.net" = {
    useACMEHost = "4kb.net";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5232/";
    };
  };
}
