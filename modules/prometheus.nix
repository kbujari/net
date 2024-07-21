{ config, ... }:
let
  port = config.services.prometheus.exporters.node.port;
in
{
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "15s";
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{
          targets = [
            "localhost:${toString port}"
          ];
        }];
      }
    ];
  };
}
