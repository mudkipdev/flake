{ config, pkgs, lib, constants, ... }:

{
  programs.git = {
    enable = true;
    userName = "mudkipdev";
    userEmail = constants.user.email;

    extraConfig = {
      init.defaultBranch = "main";
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
