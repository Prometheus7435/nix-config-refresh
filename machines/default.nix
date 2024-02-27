{ config, desktop, hostname, inputs, lib, modulesPath, outputs, pkgs, stateVersion, username, ...}: {
  # - https://nixos.wiki/wiki/Nix_Language:_Tips_%26_Tricks#Coercing_a_relative_path_with_interpolated_variables_to_an_absolute_path_.28for_imports.29
  imports = [
    inputs.disko.nixosModules.disko
    (./. + "/${hostname}/default.nix")
    (./. + "/${hostname}/disks.nix")
    (modulesPath + "/installer/scan/not-detected.nix")
    # ./_mixins/base
    # ./_mixins/boxes
    # ./_mixins/languages
    # ./_mixins/users/root
    # ../users/${username} # importing user settings from main flake
  ]
  # Only include desktop components if one is supplied.
  ++ lib.optional (builtins.isString desktop) ../traits/desktop;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };

    optimise.automatic = true;

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  system = {
    stateVersion = stateVersion;
  };
  boot = {
    kernelParams = [ ];
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
    ];

    initrd = {
      availableKernelModules = [
        "ahci"
        "ehci_pci"
        "mpt3sas"
        "nvme"
        "rtsx_pci_sdmmc"
        "usb_storage"
        "usbhid"
        "virtio_balloon"
        "virtio_blk"
        "virtio_pci"
        "virtio_ring"
        "xhci_pci"
      ];
      kernelModules = [

      ];
    };
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  services = {
    auto-cpufreq.enable = true;
    # fwupd.enable = true;
  };
}
