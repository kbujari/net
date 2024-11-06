{ outputs, lib, pkgs, modulesPath, ... }: {
  imports = [
    outputs.nixosModules.xnet
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    (modulesPath + "/installer/cd-dvd/channel.nix")
  ];

  networking.hostName = "nixiso";

  services.qemuGuest.enable = true;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = lib.mkForce "yes";
  };

  users = {
    mutableUsers = false;
    users.nixiso = {
      password = "";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  systemd = {
    services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };
}
