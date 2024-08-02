{ config, ... }: {
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "dev+certs@4kb.net";
      group = "nginx";
    };

    certs."4kb.net" = {
      extraDomainNames = [ "*.4kb.net" ];
      reloadServices = [ "nginx" ];
      directory = "/persist/certs/acme/4kb.net";
      dnsProvider = "porkbun";
      credentialsFile = "/run/porkbun";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };
}
