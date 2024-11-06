{ config, ... }: {

  networking = {
    useDHCP = false;
    dhcpcd.enable = false;
    nameservers = [ "9.9.9.9" ];
  };

  systemd.tmpfiles.rules = [
    "d /persist/data/NetworkManager 0750 - - -"
    "L+ /var/lib/NetworkManager - - - - /persist/data/NetworkManager"
  ];

  networking.networkmanager = {
    enable = true;
    dns = "none";
    wifi = {
      powersave = true;
      backend = "iwd";
    };
  };
}
