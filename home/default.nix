{ config, pkgs, inputs, lib, constants, ...}:

{
  imports = [
    ./browser.nix
    ./development.nix
    ./gaming.nix
    ./git.nix
  ];

  programs.home-manager.enable = true;

  programs.plasma = {
    enable = true;
    workspace.wallpaper = "${config.home.homeDirectory}/wallpaper.png";
  };

  home = {
    username = constants.user.name;
    stateVersion = constants.system.stateVersion;
    homeDirectory = constants.user.homeDirectory;

    file."wallpaper.png" = {
      source = ../wallpaper.png;
    };

    packages = with pkgs; [
      fastfetch
      vesktop
      spotify
      bitwarden
      qbittorrent
      micro

      (anki.withAddons [
        ankiAddons.passfail2
        ankiAddons.anki-connect
      ])

      # Creative
      obs-studio
      davinci-resolve
      aseprite
      blender
    ];

    sessionVariables = {
      EDITOR = "micro";
    };
  };
}
