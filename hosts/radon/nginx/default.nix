{ config, pkgs, ... }: {

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."_" = {
      useACMEHost = "4kb.net";
      addSSL = true;
      default = true;
      locations."/" = {
        root = pkgs.writeTextDir "index.html" (builtins.readFile ./landing-page/index.html);
        index = "index.html";
      };
    };
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

  sops.templates."ddclient.conf" = {
    content = ''
      protocol=porkbun
      apikey=${config.sops.placeholder."porkbun/api-key"}
      secretapikey=${config.sops.placeholder."porkbun/secret-api-key"}
      a-tor-ca.4kb.net
    '';
  };

  services.ddclient = {
    enable = true;
    configFile = config.sops.templates."ddclient.conf".path;
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
    "Z /certs/acme 0750 acme acme - -"
    "L+ /var/lib/acme - - - - /certs/acme"
  ];
}
