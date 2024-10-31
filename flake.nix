{
  description = "Internal network and programming lab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko/v1.6.1";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, deploy-rs, ... }:
    let
      inherit (self) inputs outputs;
      inherit (nixpkgs.lib) nixosSystem;
      inherit (nixpkgs.lib.nixosModules) xnet;

      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "riscv-linux" ];
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      nixosModules.xnet = import ./xnet;

      nixosConfigurations = {
        radon = nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs xnet; };
          modules = [ ./hosts/radon ];
        };
        t480 = nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs xnet; };
          modules = [ ./hosts/t480 ];
        };
      };

      deploy.nodes.radon = {
        hostname = "radon";
        profiles.system = {
          sshUser = "root";
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.radon;
        };
      };
    };
}
