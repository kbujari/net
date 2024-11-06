{ outputs, pkgs, ... }: {
  system.stateVersion = "24.05";

  networking.hostName = "k480";

  xnet = {
    disk = {
      enable = true;
      device = "nvme0n1";
      extraDatasets = {
        "persist/usr" = {
          type = "zfs_fs";
          mountpoint = "/home/k6";
          options.mountpoint = "legacy";
        };
      };
    };
  };

  users.mutableUsers = false;
  users.users.k6 = {
    hashedPassword = "$y$j9T$ojCv6IK3Qq0zabOgsvBD20$mGclM1Ulwmdre3Z6kTKlsxR0evIgb26a.0jZBDRLDS2";
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      git
      neovim
      mpv
      tigervnc
      zathura
    ];
  };

  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "default-off";
      SearchBar = "unified";
      ExtensionSettings = {
        "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Bitwarden:
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        # Dark Reader:
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  imports = [
    outputs.nixosModules.xnet
    ./networking.nix
    ./desktop.nix
  ];
}
