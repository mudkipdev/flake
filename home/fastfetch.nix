{ config, lib, pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
        padding = {
          right = 1;
        };
      };
      display = {
        separator = " ";
      };
      modules = [
        {
          type = "title";
          color = {
            user = "#ffffff";
            at = "#ffffff";
            host = "#ffffff";
          };
        }
        {
          type = "separator";
          string = "─────────────────────────";
          color = "#5b6078";
        }
        {
          type = "os";
          keyColor = "#ed8796";
          format = "{pretty-name}";
        }
        {
          type = "uptime";
          keyColor = "#f5a97f";
        }
        {
          type = "packages";
          keyColor = "#eed49f";
        }
        {
          type = "cpu";
          keyColor = "#a6da95";
        }
        {
          type = "gpu";
          keyColor = "#8aadf4";
          hideType = "integrated";
          format = "{name}";
        }
        {
          type = "memory";
          keyColor = "#c6a0f6";
          format = "{used} / {total}";
        }
      ];
    };
  };
}