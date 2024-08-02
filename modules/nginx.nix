{ config, ... }: {
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "dev+certs@4kb.net";
      dnsProvider = "porkbun";
      credentialsFile = "/run/porkbun";
      reloadServices = [ "nginx" ];
    };

    certs."4kb.net" = {
      extraDomainNames = [ "*.4kb.net" ];
    };
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/acme - - - - /persist/certs/acme"
  ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  users.users.nginx.extraGroups = [ "acme" ];
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };
}
