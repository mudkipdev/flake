{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.ollama-rocm ];
  
  systemd.services.ollama = {
    description = "Ollama Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    environment = {
      OLLAMA_KEEP_ALIVE = "7200";
      OLLAMA_HOST = "0.0.0.0";
    };
    
    serviceConfig = {
      ExecStart = "${pkgs.ollama-rocm}/bin/ollama serve";
      Restart = "always";
      RestartSec = 5;
      User = "ollama";
      Group = "ollama";
    };
  };
  
  users.users.ollama = {
    isSystemUser = true;
    group = "ollama";
    home = "/var/lib/ollama";
    createHome = true;
  };
  
  users.groups.ollama = {};
}