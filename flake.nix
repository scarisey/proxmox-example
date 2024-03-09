{
  description = "LXC containers for Proxmox";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    #Generators - build lxc containers
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosConfigurations = {
        jellyfin = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/jellyfin/configuration.nix
          ];
        };
      };
    };
}
