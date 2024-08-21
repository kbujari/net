{ ... }: {
  imports = [ ./jellyfin.nix ];

  users.groups.media.gid = 2000;
}
