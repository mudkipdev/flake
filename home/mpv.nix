{ ... }:

{
  programs.mpv = {
    enable = true;

    config = {
      input-default-bindings = "no";

      profile = "gpu-hq";
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      hwdec = "auto-safe";

      screenshot-format = "png";
      screenshot-png-compression = 9;
      screenshot-directory = "~/Downloads";

      cache = "yes";
      demuxer-max-bytes = "150M";

      osd-level = 1;
      osd-duration = 2000;

      save-position-on-quit = "yes";
      keep-open = "yes";

      alang = "jpn,jp,eng,en";
      slang = "eng,en";

      ytdl-format = "bestvideo[height<=1080]+bestaudio/best";
    };

    bindings = {
      ">" = "add speed 0.25";
      "<" = "add speed -0.25";
      "j" = "seek -10";
      "k" = "cycle pause";
      "l" = "seek 10";
      "LEFT" = "seek -5";
      "RIGHT" = "seek 5";
      "UP" = "add volume 5";
      "DOWN" = "add volume -5";

      "." = "frame-step";
      "," = "frame-back-step";

      "m" = "cycle mute";
      "f" = "cycle fullscreen";
      "s" = "cycle sub";
      "a" = "cycle audio";

      "SPACE" = "cycle pause";
      "ESC" = "set fullscreen no";

      "t" = "script-binding console/enable";
      "S" = "screenshot video";
    };
  };
}
