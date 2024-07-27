{ config, lib, pkgs, ... }: {
  services.prometheus.exporters = {
    smartctl = {
      enable = true;
      openFirewall = true;
      user = "root"; # Required to read all disks
    };
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [ smartmontools ];
}
