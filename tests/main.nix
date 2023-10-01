{ self, inputs, pkgs, ... }:

{
  name = "nextcloud";
#   meta.maintainers = with lib.maintainers; [ mvnetbiz ];

  nodes.machine = { lib, pkgs, config, ... }: {
    imports = [
        inputs.agenix.nixosModules.default
        inputs.nixos-generators.nixosModules.linode
        ../configuration.nix
        {
            services.nextcloud.config =  {
                adminpassFile =  lib.mkForce "${pkgs.writeText "aaa" "aaa"}";
            };
        }
    ];
  };

  testScript = { nodes, ... }: ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("nextcloud-occ status")
  '';
}
