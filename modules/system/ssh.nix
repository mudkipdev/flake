{ config, lib, ... }:

{
  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
    };
  };

  # Allow SSH from any source (firewall still blocks other ports by default).
  networking.firewall.allowedTCPPorts = [ 22 ];
}
