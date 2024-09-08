{ config, pkgs, ... }: {

  boot.kernelParams = [
    "i915.enable_guc=2"
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      intel-media-sdk
      intel-vaapi-driver
      vaapiVdpau
    ];
  };

  services.jellyfin = {
    enable = true;
    dataDir = "/persist/data/jellyfin";
    cacheDir = "${config.services.jellyfin.dataDir}/cache";
  };

  users.groups.media.members = [ config.services.jellyfin.user ];

  systemd.tmpfiles.rules = with config.services.jellyfin; [
    "d ${dataDir} 0700 ${user} ${group} -"
    "Z ${dataDir} 0700 ${user} ${group} - -"
  ];

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-ffmpeg
    jellyfin-web
  ];

  services.nginx.virtualHosts."mov.web.4kb.net" = {
    useACMEHost = "4kb.net";
    addSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:8096/";
    };
  };
}
