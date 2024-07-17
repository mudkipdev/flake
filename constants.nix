{ lib, ... }:

rec {
  user = {
    name = "mudkip";
    fullName = "mudkip";
    email = "mudkip@mudkip.dev";
    homeDirectory = "/home/mudkip";
  };

  system = {
    stateVersion = "24.05";
    timezone = "America/Denver";
    locale = "en_US.UTF-8";
  };

  keyboard = {
    layout = "us";
    variant = "";
  };
}