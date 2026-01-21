{ config, pkgs, lib, ... }:

{
  networking.networkmanager.enable = true;

  # Open port for ComfyUI
  networking.firewall.allowedTCPPorts = [ 8188 ];

  # Add ethtool for network diagnostics
  environment.systemPackages = with pkgs; [
    ethtool
  ];
}