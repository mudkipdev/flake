{ config, pkgs, lib, constants, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/gaming.nix
    ./../../modules/llama-cpp.nix
    ./../../modules/open-webui.nix
    ./../../modules/system/audio.nix
    ./../../modules/system/bluetooth.nix
    ./../../modules/system/boot.nix
    # ./../../modules/system/cloudflared.nix
    ./../../modules/system/desktop.nix
    ./../../modules/system/fonts.nix
    ./../../modules/system/locale.nix
    ./../../modules/system/networking.nix
    ./../../modules/system/ssh.nix
    ./../../modules/system/system.nix
    ./../../modules/system/virtualization.nix
    ./../../modules/vpn.nix
  ];

  networking.hostName = "desktop";

  users.users.${constants.user.name} = {
    isNormalUser = true;
    description = constants.user.fullName;
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
