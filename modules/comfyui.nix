{ config, pkgs, lib, inputs, ... }:

let
  python3WithoutTests = pkgs.python3.override {
    packageOverrides = pyfinal: pyprev: {
      mss = pyprev.mss.overridePythonAttrs (old: {
        doCheck = false;
      });
      librosa = pyprev.librosa.overridePythonAttrs (old: {
        doCheck = false;
      });
    };
  };
in
{
  imports = [
    inputs.comfyui-nix.nixosModules.default
  ];

  services.comfyui = {
    enable = true;
    cuda = false;  # Using AMD GPU with ROCm
    enableManager = true;
    port = 8188;
    dataDir = "/var/lib/comfyui";

    package = pkgs.comfyui.override {
      python3 = python3WithoutTests;
    };

    customNodes = {
      ComfyUI-Qwen-TTS = pkgs.fetchFromGitHub {
        owner = "flybirdxx";
        repo = "ComfyUI-Qwen-TTS";
        rev = "main";
        hash = "sha256-Jg6QyEVjAEKWDH9SqCR3C3UMFW6LsN7kd8mPTAN3mkQ=";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8188 ];
}
