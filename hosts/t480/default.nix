{ config, inputs, outputs, ... }: {
  system.stateVersion = "24.05";

  networking.hostName = "k480";

  xnet = {
    disk = {
      enable = true;
      devices = [ "nvme0n1" ];
      extraDatasets = {
        "persist/usr/kleidi" = {
          type = "zfs_fs";
          mountpoint = "/home/kleidi";
          options.mountpoint = "legacy";
        };
      };
    };
  };

  sops.age.sshKeyPaths = map (key: key.path) config.services.openssh.hostKeys;

  imports = [
    outputs.nixosModules.xnet
    inputs.sops-nix.nixosModules.sops
  ];
}
