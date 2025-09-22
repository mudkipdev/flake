{ config, pkgs, lib, constants, ... }:

{
  system.stateVersion = constants.system.stateVersion;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  
  virtualisation.docker.enable = true;
  users.users.${constants.user.name}.extraGroups = [ "docker" ];
}