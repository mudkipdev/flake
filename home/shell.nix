{ ... }:

{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      PS1='\[\033[01;32m\]\w\[\033[00m\] $ '
    '';
  };
}