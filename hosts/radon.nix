{ config, inputs, outputs, modulesPath, ... }: {
  system.stateVersion = "24.05";

  # boot.zfs.extraPools = [ "radon" ];
  networking.firewall.allowedTCPPorts = [ 2049 ];
  services.nfs.server = {
    enable = true;
  };

  networking = {
    hostName = "radon";
    vlans = {
      vlan4 = {
        id = 4;
        interface = "enp2s0";
      };
    };
    interfaces.vlan4.ipv4.addresses = [{
      address = "10.54.4.1";
      prefixLength = 24;
    }];
  };

  # age.secrets.porkbun = {
  #   file = ../secrets/porkbun.age;
  #   owner = "acme";
  # };

  xnet = {
    disk = {
      enable = true;
      devices = [ "nvme0n1" ];
    };
  };

  imports = [
    outputs.nixosModules.xnet
    inputs.agenix.nixosModules.default
    (modulesPath + "/installer/scan/not-detected.nix")

    ../modules/users
    ../modules/sshd
    ../xnet/monitoring
  ];
}
