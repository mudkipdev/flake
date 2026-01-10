{ config, pkgs, lib, ... }:

{
  services.openssh.enable = true;

  # one of these lines fixes bluetooth on intel AX200 and idgaf to binary search
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
        # Only disable handsfree/headset microphone profiles, keep A2DP
        # DisablePlugins = "hfp_ag,hfp_hf,hsp_ag,hsp_hs";
      };

      LE = {
        MinConnectionInterval = 7;
        MaxConnectionInterval = 9;
        ConnectionLatency = 0;
      };
    };
  };

  # services.udev.extraRules = ''
  #   # Force ATH-M50xBT2 to be headphones only, no microphone
  #   SUBSYSTEM=="sound", ATTRS{id}=="ATH-M50xBT2", ENV{PULSE_FORM_FACTOR}="headphone"
  #   SUBSYSTEM=="bluetooth", ATTR{address}=="00:0A:45:19:0C:2A", ENV{PULSE_FORM_FACTOR}="headphone"
  #   SUBSYSTEM=="sound", ATTRS{id}=="ATH-M50xBT2", ENV{SOUND_FORM_FACTOR}="headphone"
  #   SUBSYSTEM=="sound", ATTRS{id}=="ATH-M50xBT2", ENV{PULSE_INTENDED_ROLES}="music"
  # '';

  # # Configure PulseAudio to disable headset profile only
  # services.pulseaudio.extraConfig = ''
  #   load-module module-bluetooth-discover headset=disabled
  # '';

  # # Force PipeWire to only use A2DP profile  
  # services.pipewire.extraConfig.pipewire."99-bluetooth-headphone-only" = {
  #   "context.modules" = [
  #     {
  #       "name" = "libpipewire-module-filter-chain";
  #       "args" = {
  #         "node.description" = "Bluetooth Headphone Filter";
  #         "media.name" = "Bluetooth Headphone Filter";
  #         "filter.graph" = {
  #           "nodes" = [
  #             {
  #               "type" = "builtin";
  #               "name" = "null_sink";
  #               "label" = "bluetooth_headphone_only";
  #             }
  #           ];
  #         };
  #       };
  #     }
  #   ];
  # };
}
