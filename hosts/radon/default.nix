{ config, lib, inputs, outputs, ... }: {
  system.stateVersion = "24.05";

  networking.firewall.allowedTCPPorts = [ 2049 ];
  services.nfs.server = {
    enable = true;
  };

  networking.hostName = "radon";

  xnet = {
    net = {
      interface = "enp2s0";
      addr = 1;
      sshd = true;
    };
    disk = {
      enable = true;
      device = "nvme0n1";
    };
  };

  sops.age.sshKeyPaths = map (key: key.path) config.services.openssh.hostKeys;

  boot.zfs.extraPools = [ "radon" ];
  services.nginx.virtualHosts."cdn.4kb.net" = {
    useACMEHost = "4kb.net";
    addSSL = true;
    locations."/" = {
      alias = "/radon/files/srv/";
      extraConfig = ''
        autoindex on;
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "Z /radon/backup 0775 root backup - -"
  ];

  services.syncoid = {
    enable = lib.mkDefault true;
    commands."zroot/persist/data".target = "radon/backup/machines/radon/persist";
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  imports = [
    outputs.nixosModules.xnet
    inputs.sops-nix.nixosModules.sops
    ./git-server
    ./nginx
    ./media
    # ./tvwg.nix
  ];
}
