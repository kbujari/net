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

  systemd.tmpfiles.rules = [ "Z /srv/git 0755 git git - -" ];

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
    package = pkgs.cgit-pink.overrideAttrs (old: {
      postInstall = old.postInstall or "" + ''
        cp ${./cgit/cgit.css} $out/cgit/cgit.css
        cp ${./cgit/responsive.html} $out/cgit/responsive.html
      '';
    });
    nginx = {
      virtualHost = "src.web.4kb.net";
      location = "/";
    };
    extraConfig = ''
      mimetype.gif=image/gif
      mimetype.html=text/html
      mimetype.jpeg=image/jpeg
      mimetype.jpg=image/jpeg
      mimetype.pdf=application/pdf
      mimetype.png=image/png
      mimetype.svg=image/svg+xml
      readme=:README
      readme=:README.md
      readme=:README.txt
      readme=:readme
      readme=:readme.md
      readme=:readme.txt
    '';
    settings = let inherit (config.services.cgit.main.nginx) virtualHost; in {
      # source-filter = "${pkgs.cgit-pink}/lib/cgit/filters/syntax-highlighting.py";
      about-filter = "${pkgs.cgit-pink}/lib/cgit/filters/about-formatting.sh";
      clone-url = "https://${virtualHost}/$CGIT_REPO_URL git@${virtualHost}:$CGIT_REPO_URL";
      enable-commit-graph = true;
      enable-http-clone = false;
      enable-index-links = true;
      enable-remote-branches = true;
      head-include = "${pkgs.cgit-pink}/cgit/responsive.html";
      remove-suffix = true;
      robots = "noindex, nofollow";
      root-desc = "What I cannot create, I do not understand";
      root-title = virtualHost;
      section-from-path = true;
      snapshots = "tar.gz tar.bz2 zip";
    };
  };

  users.groups.git.members = [ "nginx" ];
  services.nginx.virtualHosts."${config.services.cgit.main.nginx.virtualHost}" = {
    useACMEHost = "4kb.net";
    addSSL = true;
  };
}
