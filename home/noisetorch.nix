{ pkgs, ... }:

{
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
}
