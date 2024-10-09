{ config, lib, ... }:
let
  cfg = config.xnet.net;
  inherit (lib) mkOption mkIf types;
  prefix = "10.26.4";
in
{
  options.xnet.net = {
    interface = mkOption {
      type = types.str;
      default = "";
      description = "Network interface connecting to xnet.";
    };

    addr = mkOption {
      type = types.ints.between 0 255;
      description = "Final octet for xnet address.";
      example = 4;
    };

    sshd = mkOption {
      type = types.bool;
      default = true;
      description = "Enable hardened SSH service.";
    };
  };

  # TODO:
  #   - Add assertion that each address is only used once across config
  #   - Add each host to each other hosts dns configuration
  config = mkIf (builtins.stringLength cfg.interface > 0) {
    networking.vlans = {
      "${cfg.interface}.4" = {
        inherit (cfg) interface;
        id = 4;
      };
    };

    networking.interfaces = {
      "${cfg.interface}.4".ipv4.addresses = [{
        address = "${prefix}.${toString cfg.addr}";
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
      extraConfig =
        let
          p = [
            "sk-ssh-ed25519-cert-v01@openssh.com"
            "ssh-ed25519-cert-v01@openssh.com"
            "ssh-ed25519"
          ];
        in
        "PubkeyAcceptedKeyTypes ${lib.strings.concatStringsSep "," p}";
      hostKeys = [{
        path = "/certs/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }];
    };
  };
}
