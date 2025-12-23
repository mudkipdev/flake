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
          ENABLE_OLLAMA_API = "False";
          OLLAMA_API_BASE_URL = "";
          OLLAMA_BASE_URL = "";
          OPENAI_API_BASE_URL = "http://127.0.0.1:11434/v1";
          OPENAI_API_KEY = "llama-cpp";
        };

        extraOptions = [
          "--network=host"
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
