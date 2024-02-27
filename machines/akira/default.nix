# ThinkPad X1 Tablet Gen 3
# Motherboard:
# CPU: Intel i7-8650U (8)
# GPU:
# RAM: 16GB
# NVME: 500Gb

{ config, inputs, lib, pkgs, username, modulesPath, cpu-arch, ... }:
let
  # pkgs = import <nixpkgs> {
  #   overlays = [
  #     (self: super: {
  #       stdenv = super.impureUseNativeOptimizations super.stdenv;
  #     })
  #   ];
  # };
in
{
  imports = [
    # ./disks.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x13-yoga
    # ../_mixins/services/nfs/client.nix
    ../_mixins/services/pipewire.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.requestEncryptionCredentials = true;

    kernelPackages = pkgs.linuxPackages_lqx;
    kernelParams = [ "nohibernate"];

    extraModulePackages = with config.boot.kernelPackages; [
      # acpi_call
    ];

    initrd = {
      availableKernelModules = [

      ];
      kernelModules = [

      ];
    };
  };

  swapDevices = [ ];

  # nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.hostPlatform = {
    gcc.arch = cpu-arch;
    gcc.tune = cpu-arch;
    system = "x86_64-linux"
  };
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  environment.systemPackages = with pkgs; [
    maliit-keyboard
    wacomtablet
  ];

  hardware = {
    sensor = {
      # automatic screen orientation
      iio = {
        enable = true;
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services = {
    xserver.libinput.enable = true;
    powerManagement.enable = true;
    tlp = {
      settings = {
        START_CHARGE_THRESH_BAT0 = "75";
        STOP_CHARGE_THRESH_BAT0 = "95";
      };
    };
    # fingerprint reader
    fprintd.enable = true;

  };
  security = {
    pam.services.login.fprintAuth = true;
    pam.services.xscreensaver.fprintAuth = true;
  };
  networking = {
    networkmanager = {
      enable = true;  # Easiest to use and most distros use this by default.
    };
    hostName = hostname;
    hostId = hostid;
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = false;
      # example with firewall turned on
        # enable = true;
        # allowedTCPPorts = [ 80 443 ];
        # allowedUDPPortRanges = [
        #   { from = 4000; to = 4007; }
        #   { from = 8000; to = 8010; }
      # ];
    };
  };
}
