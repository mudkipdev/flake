{ config, pkgs, lib, ... }:

let
  tunnelId = "7ebfdb56-022d-4716-ba34-c5e257713df4";
  tokenFile = "/etc/cloudflared/token";
in
{
  environment.systemPackages = [ pkgs.cloudflared ];

  users.groups.cloudflared = { };
  users.users.cloudflared = {
    isSystemUser = true;
    group = "cloudflared";
  };

  environment.etc."cloudflared/config.yml".text = ''
    tunnel: ${tunnelId}
    ingress:
      - hostname: owui.mudkip.dev
        service: http://127.0.0.1:8080
      - service: http_status:404
  '';

  systemd.services.cloudflared = {
    description = "Cloudflare Tunnel (cloudflared)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      StateDirectory = "cloudflared";
      WorkingDirectory = "/var/lib/cloudflared";
      ConditionPathExists = tokenFile;
      LoadCredential = [ "token:${tokenFile}" ];

      User = "cloudflared";
      Group = "cloudflared";
      ExecStart = "${pkgs.bash}/bin/bash -euo pipefail -c 'exec ${pkgs.cloudflared}/bin/cloudflared --no-autoupdate tunnel --config /etc/cloudflared/config.yml run --token \"$(cat \"$CREDENTIALS_DIRECTORY/token\")\"'";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
