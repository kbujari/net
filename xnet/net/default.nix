{ config, lib, ... }:
let
  cfg = config.xnet.net;
  inherit (lib) mkOption mkIf types;
in
{
  options.xnet.net = {
    interface = mkOption {
      type = types.str;
      default = "";
      description = "Network interface connecting to xnet.";
    };
  };

  config = mkIf (builtins.stringLength cfg.interface > 0) { };
}
