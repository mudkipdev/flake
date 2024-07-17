{ config, pkgs, lib, constants, ... }:

{
  time.timeZone = constants.system.timezone;
  i18n.defaultLocale = constants.system.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = constants.system.locale;
    LC_IDENTIFICATION = constants.system.locale;
    LC_MEASUREMENT = constants.system.locale;
    LC_MONETARY = constants.system.locale;
    LC_NAME = constants.system.locale;
    LC_NUMERIC = constants.system.locale;
    LC_PAPER = constants.system.locale;
    LC_TELEPHONE = constants.system.locale;
    LC_TIME = constants.system.locale;
  };
}
