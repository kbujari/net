{ config, pkgs, ... }:
let
  repodir = "/repos/git";
  account = "git";
in
{

  systemd.tmpfiles.rules = [
    "L /persist/${repodir} 0755 ${account} ${account}"
  ];

  users.groups.${account} = { };
  users.users."${account}" = {
    isSystemUser = true;
    group = "${account}";
    home = "/persist/${repodir}";
    shell = "${pkgs.git}/bin/git-shell";
  };
}
