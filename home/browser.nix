{ config, pkgs, inputs, ...}:

{
  programs.librewolf = {
    enable = true;
    settings = {
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      "privacy.clearOnShutdown_v2.cache" = false;
      "privacy.resistFingerprinting" = false;
      "media.eme.enabled" = true;
      "webgl.disabled" = false;
      "middlemouse.paste" = false;
      "general.autoScroll" = true;
    };

    profiles.default = {
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        yomitan
        darkreader
      ];
    };
  };
}
