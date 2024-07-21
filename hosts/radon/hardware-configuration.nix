{ config, lib, modulesPath, ... }: {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/persist/etc/secureboot";
  };
  boot.swraid = {
    enable = true;
    mdadmConf = ''
      ARRAY /dev/md/esp metadata=1.0 UUID=50131eb1:c81d075b:343e0ea3:bf90c8d1
    '';
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/64B3-2F12";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  fileSystems."/nix" = {
    device = "zroot/local/nix";
    fsType = "zfs";
  };

  fileSystems."/etc/nixos" = {
    device = "/persist/etc/nixos";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/var/log" = {
    device = "/persist/var/log";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/var/lib" = {
    device = "/persist/var/lib";
    fsType = "none";
    options = [ "bind" ];
  };
}
