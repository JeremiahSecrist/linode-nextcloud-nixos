{
  config,
  pkgs,
  lib,
  ...
}: {
  time.timeZone = "America/New_York";
  # security.acme.acceptTerms = true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };
  environment.systemPackages = with pkgs; [
    git
    docker-compose
  ];
  # age.secrets.secret1 = {
  #   file = ../../secrets/nextcloudPassword;
  #   # path = "/var/lib/secrets/nextcloudpass";
  #   mode = "770";
  #   owner = "nextcloud";
  # };
  security.pam = {
    enableSSHAgentAuth = true;
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
  # services.nginx = {
  #   recommendedTlsSettings = true;
  #   recommendedOptimisation = true;
  #   recommendedGzipSettings = true;
  #   recommendedProxySettings = true;
  # };
  # Forwards the Host header which is required for Nextcloud

  # services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
  #   forceSSL = true;
  #   enableACME = true;
  #   locations = {"/".proxyPass = "https://${config.services.nextcloud.hostName}";};
  # };
  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "foo@bar.com";
  # };
  users.users = {
    sky = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAGm66rJsr8vjRCYDkH4lEPncPq27o6BHzpmRmkzOiM"
      ];
      extraGroups = ["wheel" "docker"];
    };
    cye = {
      # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICeRKXdKXgdgn7AGR/wx0+0M0G4WWHIjHdPPIRYLuroS cye
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICeRKXdKXgdgn7AGR/wx0+0M0G4WWHIjHdPPIRYLuroS"
      ];
      extraGroups = ["wheel" "docker"];
    };
  };

  services.tailscale.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.liveRestore = true;
  # services.nextcloud = {
  #   enable = true;
  #   hostName = "nextcloud.arouzing.xyz";
  #   package = pkgs.nextcloud27;
  #   enableBrokenCiphersForSSE = false;
  #   https = true;
  #   configureRedis = true;
  #   phpOptions = {
  #     upload_max_filesize = lib.mkForce "16G";
  #     post_max_size = lib.mkForce "16G";
  #   };
  #   config = {
  #     adminpassFile = config.age.secrets.secret1.path;
  #   };
  # };
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
