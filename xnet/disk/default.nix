{ config, lib, inputs, ... }:
let
  cfg = config.xnet.disk;
  inherit (lib) mkOption mkIf types;
in
{
  imports = [
    ./boot.nix
    inputs.disko.nixosModules.disko
  ];

  options.xnet.disk = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Apply xnet-standard ZFS disk layout.";
    };

    hostId = mkOption {
      type = types.str;
      default = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
      description = "HostID used by ZFS, default is auto-generated from network hostname.";
    };

    devices = mkOption {
      type = types.listOf types.str;
      description = ''
        Underlying devices that build the root ZFS pool.
        Anything more than one disk results in a mirror with each device.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.hostId = cfg.hostId;

    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    boot = {
      kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
      kernelParams = [ "nohibernate" ];
      supportedFilesystems = [ "vfat" "zfs" ];
      zfs.devNodes = "/dev/disk/by-partuuid";
    };

    disko.devices = (
      if (builtins.length cfg.devices) == 1 then
        import ./layouts/single.nix (builtins.head cfg.devices)
      else
        import ./layouts/mirror.nix cfg.devices
    ) // {
      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [ "defaults" "size=2G" "mode=755" ];
      };

      zpool."zroot" = {
        type = "zpool";
        mode = mkIf (builtins.length cfg.devices > 1) "mirror";
        options = {
          # acltype = "posixacl";
          ashift = "12";
          atime = "off";
          autotrim = "on";
          canmount = "off";
          compression = "on";
          mountpoint = "none";
          normalization = "formD";
          relatime = "off";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };

        datasets = {
          "nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };

          "persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options.mountpoint = "legacy";
          };

          "persist/data" = {
            type = "zfs_fs";
            mountpoint = "/persist/data";
            options.mountpoint = "legacy";
          };
        };
      };
    };
  };
}
