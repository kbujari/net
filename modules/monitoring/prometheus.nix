{ config, ... }: {
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "15s";
    scrapeConfigs = [ {
        job_name = "node_exporter";
        relabel_configs = [{
          source_labels = [ "__address__" ];
          regex = "(.*):[0-9]+";
          target_label = "instance";
          replacement = "$1";
        }];
        static_configs = [{
          targets = [
            "radon:${toString config.services.prometheus.exporters.node.port}"
          ];
        }];
      }
    ];
  };
}
