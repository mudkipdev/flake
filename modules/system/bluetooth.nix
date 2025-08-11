{ config, pkgs, lib, ... }:

{
  # one of these lines fixes bluetooth on intel AX200 and idgaf to binary search BECAUSE IT WORKS!
  services.blueman.enable = true;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [ "btusb" "bluetooth" "btintel" ];

  boot.extraModprobeConfig = ''
    options btusb enable_autosuspend=0
    options btintel enable_autosuspend=0
    options bluetooth disable_ertm=1
    options iwlwifi power_save=0
    options iwlmvm power_scheme=1
  '';

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        Privacy = "device";
        JustWorksRepairing = "always";
        FastConnectable = true;
      };

      LE = {
        MinConnectionInterval = 7;
        MaxConnectionInterval = 9;
        ConnectionLatency = 0;
      };
    };
  };
}
