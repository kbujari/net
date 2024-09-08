{ config, ... }: {
  services.sonarr = {
    enable = true;
    dataDir = "/persist/data/sonarr";
  };

  users.groups.media.members = [ config.services.sonarr.user ];
  systemd.tmpfiles.rules = let app = config.services.sonarr; in [
    "d ${app.dataDir} 0700 ${app.user} ${app.group} -"
    "Z ${app.dataDir} 0700 ${app.user} ${app.group} - -"
  ];


  services.nginx.virtualHosts."sonarr.web.4kb.net" = {
    useACMEHost = "4kb.net";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:8989/";
    };
  };
}
