{ config, lib, ... }:
let
  cfg = config.xnet.net;
  inherit (lib) mkOption mkIf types;
  prefix = "10.24.4";
in
{
  options.xnet.net = {
    interface = mkOption {
      type = types.str;
      default = "";
      description = "Network interface connecting to xnet.";
    };

    sshd = mkOption {
      type = types.bool;
      default = true;
      description = "Enable hardened SSH service.";
    };
  };

  config = mkIf (builtins.stringLength cfg.interface > 0) {
    networking.vlans = {
      "${cfg.interface}.4" = {
        inherit (cfg) interface;
        id = 4;
      };
    };

    networking.interfaces = {
      "${cfg.interface}.4".ipv4.addresses = [{
        address = "${prefix}.1";
        prefixLength = 24;
      }];
    };

    services.openssh = {
      enable = cfg.sshd;
      startWhenNeeded = true;
      settings = {
        X11Forwarding = false;
        UsePAM = false;
        PermitRootLogin = "prohibit-password";
      };
      extraConfig = ''
        PubkeyAcceptedKeyTypes sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,ssh-ed25519
      '';
      hostKeys = [{
        path = "/certs/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }];
    };
  };
}
