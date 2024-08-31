{ config, ... }: {

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  sops.secrets = {
    "porkbun/api-key" = {
      sopsFile = ./secret.yaml;
      owner = config.users.users.acme.name;
    };
    "porkbun/secret-api-key" = {
      sopsFile = ./secret.yaml;
      owner = config.users.users.acme.name;
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "dev+certs@4kb.net";
      dnsProvider = "porkbun";
      reloadServices = [ "nginx" ];
      credentialFiles = {
        "PORKBUN_API_KEY_FILE" = config.sops.secrets."porkbun/api-key".path;
        "PORKBUN_SECRET_API_KEY_FILE" = config.sops.secrets."porkbun/secret-api-key".path;
      };
    };
    certs."4kb.net".extraDomainNames = [
      "*.4kb.net"
      "*.web.4kb.net"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /certs/acme 0750 acme acme -"
    "L+ /var/lib/acme - - - - /certs/acme"
  ];


  imports = [ ./sites/4kb.net.nix ];
}