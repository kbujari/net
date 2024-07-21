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
  };
}
