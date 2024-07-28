{ lib, ... }: {
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  time.timeZone = lib.mkDefault "America/Toronto";

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
}
