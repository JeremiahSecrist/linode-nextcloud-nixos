{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

    boot = {
    # Add kernel modules detected by nixos-generate-config:
    initrd.availableKernelModules = [
      "virtio_pci"
      "virtio_scsi"
      "ahci"
      "sd_mod"
    ];

    growPartition = true;

    # Set up LISH serial connection:
    kernelParams = ["console=ttyS0,19200n8"];

    loader = {
      # Increase timeout to allow LISH connection:
      timeout = lib.mkForce 10;

      grub = {
        enable = true;
        forceInstall = true;
        device = "nodev";
        fsIdentifier = "label";

        # Allow serial connection for GRUB to be able to use LISH:
        extraConfig = ''
          serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
          terminal_input serial;
          terminal_output serial
        '';

        # Link /boot/grub2 to /boot/grub:
        extraInstallCommands = ''
          ${pkgs.coreutils}/bin/ln -fs /boot/grub /boot/grub2
        '';

        # Remove GRUB splash image:
        splashImage = null;
      };
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f222513b-ded1-49fa-b591-20ce86a2fe7f";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/f1408ea6-59a0-11ed-bc9d-525400000001"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;
  # networking.interfaces.tailscale0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
