{ config, ... }: {
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "15s";
    scrapeConfigs = [{
      job_name = "node";
      relabel_configs = [{
        source_labels = [ "__address__" ];
        regex = "(.*):[0-9]+";
        target_label = "instance";
        replacement = "$1";
      }];
    }];
  };
}
