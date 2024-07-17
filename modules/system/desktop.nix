{ config, pkgs, inputs, constants, ... }:

{
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = constants.keyboard.layout;
    variant = constants.keyboard.variant;
  };
}
