{ config, lib, pkgs, ... }: {
  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "processes" "systemd" ];
      openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [ smartmontools ];
}
