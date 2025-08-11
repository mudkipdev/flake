{ config, pkgs, lib, constants, ... }:

{
  programs.git = {
    enable = true;
    userName = "mudkipdev";
    userEmail = constants.user.email;

    extraConfig = {
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      pull.rebase = true;
      core.editor = "micro";
    };
  };

  home.packages = with pkgs; [
    gh
  ];
}