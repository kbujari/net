{ config, ... }: {
  services.prometheus.exporters = {
    smartctl = {
      enable = true;
    };
    node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
    };
  };
}
