{ config, pkgs, inputs, lib, constants, ...}:

{
  imports = [
    ./browser.nix
    ./btop.nix
    ./development.nix
    ./discord.nix
    ./fastfetch.nix
    ./git.nix
    ./minecraft.nix
    ./mpv.nix
    ./noisetorch.nix
    ./shell.nix
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
      kdePackages.kdenlive
      kdePackages.kcolorchooser
      aseprite
      blender
      ffmpeg
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
