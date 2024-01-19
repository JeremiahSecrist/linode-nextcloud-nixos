{
  config,
  pkgs,
  lib,
  ...
}:
let
  defaultGroups = ["wheel" "docker"];
in {
  time.timeZone = "America/New_York";
  # security.acme.acceptTerms = true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };
  environment.systemPackages = with pkgs; [
    git
    docker-compose
    micro
  ];
  programs.bash.shellAliases = {
    rbsw = "sudo nixos-rebuild switch --flake github:JeremiahSecrist/linode-nextcloud-nixos";
  };

  # age.secrets.secret1 = {
  #   file = ../../secrets/nextcloudPassword;
  #   # path = "/var/lib/secrets/nextcloudpass";
  #   mode = "770";
  #   owner = "nextcloud";
  # };
  security.pam = {
    sshAgentAuth.enable = true;
    services.sudo.sshAgentAuth = true;
  };
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
    startWhenNeeded = true;
    # kexAlgorithms = [ "curve25519-sha256@libssh.org" ];
  };
  users.users = {
    sky = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAGm66rJsr8vjRCYDkH4lEPncPq27o6BHzpmRmkzOiM"
      ];
      extraGroups = defaultGroups;
    };
    cye = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICeRKXdKXgdgn7AGR/wx0+0M0G4WWHIjHdPPIRYLuroS"
      ];
      extraGroups = defaultGroups;
    };
  };
  services.tailscale.enable = true;
  virtualisation = {
    docker = {
      enable = true;
      liveRestore = true;
    };
  };
  networking.firewall.allowedTCPPorts = [22 80 443 3000];
  system.stateVersion = "23.11";
  system.autoUpgrade = {
    dates = "daily";
    enable = true;
    allowReboot = false;
    randomizedDelaySec = "60min";
    flake = "github:JeremiahSecrist/linode-nextcloud-nixos";
  };
  networking.hostName = "nextcloud";
}
