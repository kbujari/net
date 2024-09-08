{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
in
{
  imports = [
    ./disk
    ./net
    ./monitoring
    ./users
  ];

  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  time.timeZone = mkDefault "America/Toronto";

  environment.systemPackages = with pkgs; [ vim git ];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false;
  };

  nix.gc = {
    automatic = true;
    options = mkDefault "--delete-older-than 30d";
  };
}
