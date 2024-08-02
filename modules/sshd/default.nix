{ config, ... }: {
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      X11Forwarding = false;
      UsePAM = false;
      PermitRootLogin = "prohibit-password";
    };
    extraConfig = ''
      PubkeyAcceptedKeyTypes sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,ssh-ed25519
    '';
    hostKeys = [
      {
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
