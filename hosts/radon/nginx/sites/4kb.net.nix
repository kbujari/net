{ ... }: {
  services.nginx.virtualHosts."4kb.net" = {
    useACMEHost = "4kb.net";
    addSSL = true;
    root = "/srv/www/4kb.net/";
  };
}
