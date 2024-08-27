{ pkgs, ... }: {

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  boot.kernelParams = [
    "i915.enable_guc=2"
  ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vaapiVdpau
      intel-compute-runtime
      intel-media-sdk
    ];
  };

  services.jellyfin = {
    enable = true;
    dataDir = "/persist/data/jellyfin";
  };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  services.nginx.virtualHosts."mov.web.4kb.net" = {
    locations."/" = {
      proxyPass = "http://localhost:8096/";
    };
  };
}
