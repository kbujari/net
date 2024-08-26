{ config, pkgs, inputs, ... }: {
  services.gitDaemon = {
    enable = true;
    exportAll = true;
    basePath = "/srv/git";
  };

  xnet.disk.extraDatasets = {
    "persist/data/repos" = {
      type = "zfs_fs";
      mountpoint = "/srv/git";
      options.mountpoint = "legacy";
    };
  };

  networking.firewall.allowedTCPPorts = [ config.services.gitDaemon.port ];

  users.groups.git = { };
  users.users."git" = {
    isSystemUser = true;
    home = "/srv/git";
    initialPassword = "";
    createHome = true;
    shell = "${pkgs.git}/bin/git-shell";
    packages = with pkgs; [ git ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPIOY5gZ86K9cWq2Qa/AhLtNtt0QBQHNM+n2WaeLp2n"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7T2uWJFUu8aFZZgQusGKyEMocb2pKbHLDad2eIJus9"
    ];
  };
}
