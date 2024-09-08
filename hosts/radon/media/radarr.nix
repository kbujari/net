{ config, ... }: {
  services.radarr = {
    enable = true;
    dataDir = "/persist/data/radarr";
  };

  users.groups.media.members = [ config.services.radarr.user ];
  systemd.tmpfiles.rules = let app = config.services.radarr; in [
    "d ${app.dataDir} 0700 ${app.user} ${app.group} -"
    "Z ${app.dataDir} 0700 ${app.user} ${app.group} - -"
  ];


  services.nginx.virtualHosts."radarr.web.4kb.net" = {
    useACMEHost = "4kb.net";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:7878/";
    };
  };
}
