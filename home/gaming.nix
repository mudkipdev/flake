{ config, pkgs, lib, inputs, ...}:

{
  home.packages = with pkgs; [
    (prismlauncher.override {
      jdks = [ jdk21 ];
    })

    lunar-client
    jdk21
  ];
}