{ config, pkgs, inputs, lib, constants, ...}:

{
  imports = [
    ./browser.nix
    ./development.nix
    ./gaming.nix
    ./git.nix
    ./fastfetch.nix
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

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      PS1='\[\033[01;32m\]\w\[\033[00m\] $ '

      function qwen () {
        MODEL="beast:latest"
        ANTHROPIC_BASE_URL=http://localhost:8080/anthropic ANTHROPIC_AUTH_TOKEN="dummy-key" API_TIMEOUT_MS=600000 ANTHROPIC_MODEL=ollama/$MODEL ANTHROPIC_SMALL_FAST_MODEL=ollama/$MODEL claude
      }
    '';
  };
}
