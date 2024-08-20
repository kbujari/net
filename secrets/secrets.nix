{ config, ... }:
let
  radon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+gqBhOE/CLvYCV56OMx7dm1i1Jcs2wrxkE5I+RbXcj";
in
{
  "porkbun.age".publicKeys = [ radon ];
}
