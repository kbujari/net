{ config, pkgs, ... }: {

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver # previously vaapiIntel
      vaapiVdpau
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      intel-media-sdk # QSV up to 11th gen
    ];
  };

  services.jellyfin = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [ jellyfin jellyfin-web jellyfin-ffmpeg ];

  users.users.jellyfin.extraGroups = [ "media" ];

  services.nginx.virtualHosts."mov.web.4kb.net" = {
    locations."/" = {
      proxyPass = "http://localhost:8096/";
    };
  };
}
