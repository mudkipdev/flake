{...}:

{
  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop.enable = true;

    # Custom style which removes some UI clutter
    quickCss = builtins.readFile ./discord.css;

    config = {
      useQuickCss = true;
      frameless = false;

      plugins = {
        # Disables suspicious link/file pop-ups
        alwaysTrust.enable = true;

        # Gives every user a random name color
        ircColors = {
          enable = true;
          lightness = 75;
        };

        # Shows deleted messages
        messageLogger = {
          enable = true;
          deleteStyle = "overlay";
          ignoreSelf = true;
        };

        # Lets you see the permissions granted for a specific user/role
        permissionsViewer.enable = true;

        # Shows channels which you don't have permission for in the channel list
        showHiddenChannels.enable = true;

        # Shows users' display names instead of their server nicknames
        showMeYourName = {
          enable = true;
          # TODO: mode=username only, displayNames=true, inReplies=true
        };
      };
    };
  };
}