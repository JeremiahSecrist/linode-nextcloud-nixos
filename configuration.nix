{
    config,
    pkgs,
    lib,
    ...
}:{
    time.timeZone = "America/New_York";
    security.acme.acceptTerms = true;
    security.pam = {
        enableSSHAgentAuth = true;
        services.sudo.sshAgentAuth = true;
    };
    services.openssh = {
        enable = true;
        openFirewall = true;
        # settings = {
            # PasswordAuthentication = false;
            # PermitRootLogin = "no";
            # KbdInteractiveAuthentication = false;
        # };
        startWhenNeeded = true;
        # kexAlgorithms = [ "curve25519-sha256@libssh.org" ];
    };
    services.nginx.virtualHosts."nextcloud.arouzing.xyz" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyWebsockets = true;
    };
    users.users = {
        sky = {
            isNormalUser = true;
            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAGm66rJsr8vjRCYDkH4lEPncPq27o6BHzpmRmkzOiM"
            ];
            extraGroups = [ "wheel" ];
        };
    };
    services.nextcloud = {
        enable = true;
        hostName = "nextcloud.arouzing.xyz";
        package = pkgs.nextcloud27;
        enableBrokenCiphersForSSE = false;
        https = true;
        configureRedis = true;
        phpOptions = {
            upload_max_filesize = "16G";
            post_max_size = "16G";
        };
        config = {
            # adminpassFile = (pkgs.writeText "adminpass" "test123");
            extraTrustedDomains = [ "nixos" ];
        };
    };
}
