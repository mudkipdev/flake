{ config, pkgs, ... }:

{
  services.mullvad-vpn.enable = true;
  services.tailscale.enable = true;

  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ 5900 6080 ];
  };
}
