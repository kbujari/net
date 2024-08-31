{ config, pkgs, ... }: {

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  boot.kernelParams = [
    "i915.enable_guc=2"
  ];

  hardware.opengl = {
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
    cacheDir = "${config.services.jellyfin.dataDir}/cache";
  };

  systemd.tmpfiles.rules =
    let
      path = "/persist/data/jellyfin";
      app = config.services.jellyfin;
    in
    [
      "d ${path} 0700 ${app.user} ${app.group} -"
      "L+ ${app.dataDir} 0700 - - - ${path}"
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
