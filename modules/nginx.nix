{ config, ... }: {
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "dev+certs@4kb.net";
    };

    certs."4kb.net" = {
      extraDomainNames = [ "*.4kb.net" ];
      directory = "/persist/certs/acme/4kb.net";
      dnsProvider = "porkbun";
      credentialsFile = "/run/porkbun";
      reloadServices = [ "nginx" ];
    };
  };

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
