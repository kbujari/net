{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  environment.systemPackages = with pkgs; [
    sbctl
  ];

  users.mutableUsers = false;
  users.users.root.initialPassword = "alpine";

  networking.hostName = "radon";
  networking.hostId = "71023948";

  system.stateVersion = "24.11";
}
