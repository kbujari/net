{ config, inputs, lib, ... }: {
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
    kernelModules = [ "kvm-intel" "kvm-amd" ];

    lanzaboote = {
      enable = true;
      pkiBundle = "/persist/certs/secureboot";
    };
  };

  systemd.tmpfiles.rules = [
    "L /etc/secureboot - - - - /persist/certs/secureboot"
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
