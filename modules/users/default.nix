{ config, ... }: {
  users.mutableUsers = false;
  users.users.root = {
    initialPassword = "radon";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPIOY5gZ86K9cWq2Qa/AhLtNtt0QBQHNM+n2WaeLp2n"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7T2uWJFUu8aFZZgQusGKyEMocb2pKbHLDad2eIJus9"
    ];
  };

  /*
     users.users.kbujari = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "kvm"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPIOY5gZ86K9cWq2Qa/AhLtNtt0QBQHNM+n2WaeLp2n"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7T2uWJFUu8aFZZgQusGKyEMocb2pKbHLDad2eIJus9"
    ];
    };
  */
}
