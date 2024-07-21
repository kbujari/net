{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/users
    ../../modules/sshd
    ../../modules/nginx.nix
    ../../modules/grafana.nix
    ../../modules/node_exporter.nix
    ../../modules/prometheus.nix
  ];

  environment.systemPackages = with pkgs; [
    sbctl
  ];

  networking.hostName = "radon";
  networking.hostId = "71023948";

  system.stateVersion = "24.11";
}
