{ config, lib, inputs, modulesPath, ... }:
let
  cfg = config.xnet.disk;
  commonOpts = {
    acltype = "posixacl";
    atime = "off";
    compression = "on";
    normalization = "formD";
    relatime = "off";
    xattr = "sa";
    "com.sun:auto-snapshot" = "false";
  };

  inherit (lib) mkOption mkIf types;
in
{
  imports = [
    ./boot.nix
    inputs.disko.nixosModules.disko
    (modulesPath + "/installer/scan/not-detected.nix")
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

    device = mkOption {
      type = types.str;
      description = "Underlying device that build the root ZFS pool.";
    };

    extraDatasets = mkOption { };
  };

  config = mkIf cfg.enable {
    networking.hostId = cfg.hostId;

    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    boot = {
      kernelParams = [ "nohibernate" "elevator=none" ];
      supportedFilesystems = [ "vfat" "zfs" ];
      zfs.devNodes = "/dev/disk/by-partuuid";
    };

    disko.devices = (import ./layouts/single.nix cfg.device) // {
      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [ "defaults" "size=2G" "mode=755" ];
      };

      zpool.zroot = {
        type = "zpool";
        options = {
          ashift = "12";
          autotrim = "on";
        };

        datasets = {
          "local" = {
            type = "zfs_fs";
            options = commonOpts;
          };

          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };

          "local/certs" = {
            type = "zfs_fs";
            mountpoint = "/certs";
            options.mountpoint = "legacy";
          };

          "persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options = { mountpoint = "legacy"; } // commonOpts;
          };

          "persist/data" = {
            type = "zfs_fs";
            mountpoint = "/persist/data";
            options.mountpoint = "legacy";
          };
        } // cfg.extraDatasets;
      };
    };

    users.groups.backup = {
      members = [ config.services.syncoid.group ];
      gid = 2001;
    };
  };
}
