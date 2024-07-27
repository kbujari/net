{ config, pkgs, ... }: {
  services.prometheus.exporters = {
    smartctl = {
      enable = true;
    };
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
    };
  };

  environment.systemPackages = with pkgs; [ smartmontools ];
}
