{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixos-generators = {
            url = "github:nix-community/nixos-generators";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    outputs = inputs:
    with inputs;
    let
        # supportedSystems = ["x86_64-linux" "x86-linux"];
        defaultSystem = "x86_64-linux";
        specialArgs = {inherit self inputs;};
        # forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
        sharedModules = [
            nixos-generators.nixosModules.all-formats
        ];
        mkNixos = system: systemModules: config: nixpkgs.lib.nixosSystem {
            inherit system specialArgs;
            modules = sharedModules ++ systemModules ++ [
                config
            ];
        };
    in {
        nixosConfigurations = {
            test = mkNixos defaultSystem [
                nixos-generators.nixosModules.linode
                ] ./configuration.nix;
        };
        packages.x86_64-linux = {
            linode = self.nixosConfigurations.test.config.formats.linode;
        };
    };
}
