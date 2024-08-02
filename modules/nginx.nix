{ config, ... }: {
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "dev+certs@4kb.net";
      group = "nginx";
      dnsProvider = "porkbun";
      credentialsFile = "/run/porkbun";
      reloadServices = [ "nginx" ];
    };

    certs."4kb.net" = {
      extraDomainNames = [ "*.4kb.net" ];
      directory = "/persist/certs/acme/4kb.net";
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
