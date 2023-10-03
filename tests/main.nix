{
  self,
  inputs,
  pkgs,
  ...
}: {
  name = "nextcloud";
  nodes.machine = {
    lib,
    pkgs,
    config,
    ...
  }: {
    imports = [
      inputs.agenix.nixosModules.default
      inputs.nixos-generators.nixosModules.linode
      self.nixosModules.nextcloud
      {
        services.tailscale.enable = lib.mkForce false;
        services.nextcloud.config = {
          adminpassFile = lib.mkForce "${pkgs.writeText "aaa" "aaa"}";
        };
      }
    ];
  };

  testScript = {nodes, ...}: ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("nextcloud-occ status")
  '';
}
