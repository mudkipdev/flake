{ config, pkgs, lib, ... }:

{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      open-webui = {
        image = "ghcr.io/open-webui/open-webui:main";
        volumes = [ "open-webui:/app/backend/data" ];
        environment = {
          OLLAMA_BASE_URL = "http://127.0.0.1:11434";
        };
        extraOptions = [
          "--network=host"
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
