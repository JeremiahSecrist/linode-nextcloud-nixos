{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    with inputs; let
      # supportedSystems = ["x86_64-linux" "x86-linux"];
      defaultSystem = "x86_64-linux";
      specialArgs = {inherit self inputs;};
      # forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      sharedModules = [
        agenix.nixosModules.default
      ];
      mkNixos = system: systemModules: config:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules =
            sharedModules
            ++ systemModules
            ++ [
              config
            ];
        };
    in {
      nixosConfigurations = {
        test =
          mkNixos defaultSystem [
            nixos-generators.nixosModules.linode
          ]
          ./configuration.nix;
      };
      packages.x86_64-linux = {
        linode = nixos-generators.nixosGenerate {
          system = defaultSystem;
          modules = [
            # you can include your own nixos configuration here, i.e.
            agenix.nixosModules.default
            ./configuration.nix
          ];
          format = "linode";
        };
      };
    };
}
