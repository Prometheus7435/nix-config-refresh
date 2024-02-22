{
  description =
    "My NixOS config that's 'inspired' from Wimpy's NixOS and Home Manager Configuration basing from the nix-starter-config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      # url = "github:nix-community/home-manager/release-23.05";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # customize keyboard in Wayland
    # xremap-flake = {
    #   url = "github:xremap/nix-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.home-manager.follows = "home-manager";
    # };

  };

  outputs = {
    self,
      nixpkgs,
      home-manager,
      plasma-manager,
      nixos-hardware,
      emacs-overlay,
      disko,
      nur,
      ...
  }: {

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      akira = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        gcc.arch = "znver2";
        gcc.tune = "znver2";
        specialArgs = {
          inherit inputs outputs stateVersion;
          desktop = "kde";
          hostid = "1a74de91"; # head -c 8 /etc/machine-id
          hostname = "akira";
          username = "shyfox";
        };
        stateVersion = "23.11";
        modules = [
          ./nixos
          # nur.nixosModules.nur
        ];
      };
    };
  };
}
