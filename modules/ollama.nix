{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.ollama-rocm pkgs.rocmPackages.rocm-runtime ];

  networking.firewall.allowedTCPPorts = [ 11434 ];

  systemd.services.ollama = {
    description = "Ollama Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      OLLAMA_KEEP_ALIVE = "7200";
      OLLAMA_HOST = "0.0.0.0";
      HSA_OVERRIDE_GFX_VERSION = "10.3.0";
      ROCM_PATH = "${pkgs.rocmPackages.rocm-runtime}";
      HIP_VISIBLE_DEVICES = "0";
      GPU_MAX_HW_QUEUES = "2";
    };

    serviceConfig = {
      ExecStart = "${pkgs.ollama-rocm}/bin/ollama serve";
      Restart = "always";
      RestartSec = 5;
      User = "ollama";
      Group = "ollama";
      SupplementaryGroups = [ "video" "render" ];
    };
  };

  users.users.ollama = {
    isSystemUser = true;
    group = "ollama";
    extraGroups = [ "video" "render" ];
    home = "/var/lib/ollama";
    createHome = true;
  };

  users.groups.ollama = {};
}