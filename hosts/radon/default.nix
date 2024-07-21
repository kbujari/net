{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/users
    ../../modules/sshd
  ];

  environment.systemPackages = with pkgs; [
    sbctl
  ];

  networking.hostName = "radon";
  networking.hostId = "71023948";

  system.stateVersion = "24.11";
}
