{ config, pkgs, inputs, lib, constants, ...}:

{
  imports = [
    ./browser.nix
    ./btop.nix
    ./development.nix
    ./gaming.nix
    ./git.nix
    ./fastfetch.nix
  ];

  programs.home-manager.enable = true;

  # Fix fcitx5 package path issue
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs.kdePackages; [ fcitx5-with-addons ];
  };

  programs.plasma = {
    enable = true;
    workspace.wallpaper = "${config.home.homeDirectory}/wallpaper.png";
  };

  programs.micro = {
    enable = true;
    settings.eofnewline = false;
  };

  home = {
    username = constants.user.name;
    stateVersion = constants.system.stateVersion;
    homeDirectory = constants.user.homeDirectory;

    file."wallpaper.png" = {
      source = ../wallpaper.png;
    };

    packages = with pkgs; [
      vesktop
      spotify
      bitwarden-desktop
      qbittorrent
      deskflow

      (anki.withAddons [
        ankiAddons.passfail2
        ankiAddons.anki-connect
      ])

      # Creative
      obs-studio
      davinci-resolve
      aseprite
      blender

      # Gaming
      # ninecraft
    ];

    sessionVariables = {
      EDITOR = "micro";
    };
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      PS1='\[\033[01;32m\]\w\[\033[00m\] $ '
    '';
  };
}
