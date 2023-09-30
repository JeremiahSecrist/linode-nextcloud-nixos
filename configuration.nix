{
  config,
  pkgs,
  lib,
  ...
}: {
  time.timeZone = "America/New_York";
  # security.acme.acceptTerms = true;
  age.secrets.secret1 = {
    file = ./secrets/nextcloudPassword;
    # path = "/var/lib/secrets/nextcloudpass";
    mode = "770";
    owner = "nextcloud";
  };
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
  services.nginx = {
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };
  # Forwards the Host header which is required for Nextcloud

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
    locations = { "/".proxyPass = "https://${config.services.nextcloud.hostName}"; };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "foo@bar.com";
  };
  users.users = {
    sky = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAGm66rJsr8vjRCYDkH4lEPncPq27o6BHzpmRmkzOiM"
      ];
      extraGroups = ["wheel"];
    };
  };
  services.tailscale.enable = true;
  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.arouzing.xyz";
    package = pkgs.nextcloud27;
    enableBrokenCiphersForSSE = false;
    https = true;
    configureRedis = true;
    phpOptions = {
      upload_max_filesize = lib.mkForce "16G";
      post_max_size = lib.mkForce "16G";
    };
    config = {
      adminpassFile = config.age.secrets.secret1.path;
    };
  };
  networking.firewall.allowedTCPPorts = [22 80 443];
  system.stateVersion = "23.05";
  system.autoUpgrade = {
    dates = "daily";
    enable = true;
    allowReboot = true;
    randomizedDelaySec = "60min";
    flake = "github:jeremiahSecrist/linode-nextcloud-nixos";
  };
}
