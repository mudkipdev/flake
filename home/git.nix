{ config, pkgs, lib, constants, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user.name = "mudkipdev";
      user.email = constants.user.email;

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
