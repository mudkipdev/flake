{
  description = "My personal NixOS configuration for my computer.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comfyui-nix = {
      url = "github:utensils/comfyui-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs, home-manager, plasma-manager, firefox-addons, rust-overlay, comfyui-nix, nixcord, ... }:
  let
    constants = import ./constants.nix { inherit (nixpkgs) lib; };
  in
  {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/desktop

          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              rust-overlay.overlays.default
              comfyui-nix.overlays.default
            ];
          })

          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users.${constants.user.name} = import ./home;
              extraSpecialArgs = { inherit inputs constants; };
              sharedModules = [
                plasma-manager.homeModules.plasma-manager
                nixcord.homeModules.nixcord
              ];
            };
          }
        ];

        specialArgs = { inherit inputs constants; };
      };
    };
  };
}
