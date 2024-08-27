{ outputs, ... }: {
  system.stateVersion = "24.05";

  boot.zfs.extraPools = [ "radon" ];
  networking.firewall.allowedTCPPorts = [ 2049 ];
  services.nfs.server = {
    enable = true;
  };

  networking.hostName = "radon";

  xnet = {
    net = {
      interface = "enp2s0";
      sshd = true;
    };
    disk = {
      enable = true;
      devices = [ "nvme0n1" ];
    };
  };


  imports = [
    outputs.nixosModules.xnet
    ./git-server
    ./nginx.nix
    ./jellyfin.nix
  ];
}
