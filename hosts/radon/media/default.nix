{ ... }: {
  imports = [
    ./jellyfin.nix
    ./radarr.nix
    ./sonarr.nix
  ];

  users.groups.media = {
    members = [ ];
    gid = 2000;
  };
}
