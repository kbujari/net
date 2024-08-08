let
  radon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO43RsGGAyXX9AIDjErBXdHXEcr6hEi38LNj+1fpUdHm";
in
{
  "porkbun.age".publicKeys = [ radon ];
}
