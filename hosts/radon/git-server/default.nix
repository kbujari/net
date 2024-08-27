{ config, pkgs, ... }:
let
  gitPath = "/srv/git";
in
{
  xnet.disk.extraDatasets = {
    "persist/data/repos" = {
      type = "zfs_fs";
      mountpoint = gitPath;
      options.mountpoint = "legacy";
    };
  };

  services.sanoid = {
    enable = true;
    datasets."zroot/persist/data/repos" = {
      autosnap = true;
      autoprune = true;
      hourly = 36;
      daily = 30;
      monthly = 3;
      yearly = 1;
    };
  };

  users.users.git = {
    isSystemUser = true;
    createHome = true;
    packages = with pkgs; [ git ];
    home = gitPath;
    shell = "${pkgs.git}/bin/git-shell";
    initialPassword = "";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPIOY5gZ86K9cWq2Qa/AhLtNtt0QBQHNM+n2WaeLp2n"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7T2uWJFUu8aFZZgQusGKyEMocb2pKbHLDad2eIJus9"
    ];
  };

  networking.firewall.allowedTCPPorts = [ config.services.gitDaemon.port ];
  services.gitDaemon = {
    enable = true;
    exportAll = true;
    basePath = gitPath;
  };

  services.cgit.main = {
    enable = true;
    scanPath = gitPath;
    package = pkgs.cgit-pink;
    nginx = {
      virtualHost = "src.web.4kb.net";
      location = "/";
    };
    extraConfig = ''
      readme=README
      readme=readme
      readme=readme.txt
      readme=README.txt
      readme=readme.md
      readme=README.md
    '';
    settings = with config.services.cgit.main.nginx; {
      enable-commit-graph = true;
      enable-http-clone = false;
      enable-index-links = true;
      enable-remote-branches = true;
      root-title = virtualHost;
      root-desc = "That which I cannot create, I do not understand";
      remove-suffix = true;
      section-from-path = true;
      clone-url = "http://${virtualHost}/$CGIT_REPO_URL git@${virtualHost}:$CGIT_REPO_URL";
      about-filter = "${pkgs.cgit-pink}/lib/cgit/filters/about-formatting.sh";
      source-filter = "${pkgs.cgit-pink}/lib/cgit/filters/syntax-highlighting.py";
      snapshots = "tar.gz tar.bz2 zip";
    };
  };
}
