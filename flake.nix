{
  description = "Internal network and programming lab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    hardware.url = "github:nixos/nixos-hardware";

    agenix.url = "github:ryantm/agenix";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }:
    let
      inherit (self) inputs outputs;
      inherit (nixpkgs.lib) nixosSystem;

      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      nixosConfigurations = {
        radon = nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/radon.nix ];
        };
      };
    };
}
