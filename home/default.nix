{ config, pkgs, inputs, lib, constants, ...}:

{
  imports = [
    ./browser.nix
    ./btop.nix
    ./development.nix
    ./gaming.nix
    ./git.nix
    ./fastfetch.nix
    ./mpv.nix
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

  systemd.user.services.noisetorch = {
    Unit = {
      Description = "NoiseTorch Noise Suppression";
      After = [ "pipewire.service" "wireplumber.service" ];
      Requires = [ "pipewire.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = pkgs.writeShellScript "noisetorch-start" ''
        PATH=${pkgs.coreutils}/bin:${pkgs.gnugrep}/bin:$PATH
        ${pkgs.noisetorch}/bin/noisetorch -i -t 50
        ${pkgs.coreutils}/bin/sleep 2
        SOURCE=$(${pkgs.wireplumber}/bin/wpctl status | ${pkgs.gnugrep}/bin/grep -i noisetorch | ${pkgs.gnugrep}/bin/grep -oP '\d+(?=\. NoiseTorch)')
        if [ -n "$SOURCE" ]; then
          ${pkgs.wireplumber}/bin/wpctl set-volume $SOURCE 60%
          ${pkgs.wireplumber}/bin/wpctl set-default $SOURCE
        fi
      '';
      ExecStop = "${pkgs.noisetorch}/bin/noisetorch -u";
      RemainAfterExit = true;
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
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
      ffmpeg

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
