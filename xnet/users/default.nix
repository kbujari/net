{ config, lib, ... }: {
  imports = [ ./radicale.nix ];

  sops.secrets = {
    "root" = {
      sopsFile = ./secret.yaml;
      neededForUsers = true;
    };
    "kleidi" = {
      sopsFile = ./secret.yaml;
      neededForUsers = true;
    };
  };

  users.mutableUsers = false;
  users.users = {
    root = {
      hashedPasswordFile = config.sops.secrets.root.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPIOY5gZ86K9cWq2Qa/AhLtNtt0QBQHNM+n2WaeLp2n"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7T2uWJFUu8aFZZgQusGKyEMocb2pKbHLDad2eIJus9"
      ];
    };

    kleidi = {
      hashedPasswordFile = config.sops.secrets.kleidi.path;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPIOY5gZ86K9cWq2Qa/AhLtNtt0QBQHNM+n2WaeLp2n"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7T2uWJFUu8aFZZgQusGKyEMocb2pKbHLDad2eIJus9"
      ];
    };
  };
}
