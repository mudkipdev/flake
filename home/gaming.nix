{ config, pkgs, lib, inputs, ...}:

{
  home.packages = with pkgs; [
    (prismlauncher.override {
      jdks = [
        jdk21
        jdk8
      ];
    })

    lunar-client
    classicube
    inputs.voxel-thing.packages.${pkgs.system}.default
  ];
}