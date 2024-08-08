{
  description = "Internal network and programming lab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    agenix.url = "github:ryantm/agenix";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko/v1.6.1";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }:
    let
      inherit (self) inputs outputs;
      inherit (nixpkgs.lib) nixosSystem;

      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "riscv-linux" ];
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      nixosModules.xnet = import ./xnet;

      nixosConfigurations = {
        radon = nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/radon.nix ];
        };
      };
    };
}
