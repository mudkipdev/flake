{ config, pkgs, lib, ... }:

let
  modelsDirectory = "/var/lib/llama-cpp/models";

  models = {
    glm = import ./models/glm.nix { inherit modelsDirectory; };
    qwen3-vl = import ./models/qwen3-vl.nix { inherit modelsDirectory; };
  };

  presetModels = lib.mapAttrs
    (name: model:
      let
        baseSettings =
          model.settings
          // (if model ? model then { model = model.model; } else { "hf-repo" = model."hf-repo"; });
      in
        if name == config.services.llama-cpp-router.defaultModel then
          baseSettings // { "load-on-startup" = true; }
        else
          baseSettings
    )
    models;

  modelsPresetFile = pkgs.writeText "llama-cpp-models.ini" (
    lib.generators.toINI { } ({ version = 1; } // presetModels)
  );

  routerArgs = [
    "--host"
    "0.0.0.0"
    "--port"
    "11434"
    "--models-dir"
    modelsDirectory
    "--models-max"
    (builtins.toString config.services.llama-cpp-router.modelsMax)
    "--models-preset"
    modelsPresetFile
  ];
in {
  options.services.llama-cpp-router = {
    defaultModel = lib.mkOption {
      type = lib.types.enum (builtins.attrNames models);
      default = "glm";
      description = "Model preset to load on startup for the llama.cpp router server.";
    };
    modelsMax = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Maximum number of models to keep loaded simultaneously.";
    };
  };

  config = {
    # Override llama-cpp with ROCm support and optimizations
    nixpkgs.overlays = [
      (final: prev: {
        llama-cpp-rocm = (prev.llama-cpp.override {
          rocmSupport = true;
          cudaSupport = false;
          metalSupport = false;
          blasSupport = true; # Significantly improves CPU offload performance
        }).overrideAttrs (oldAttrs: {
          cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
            "-DGGML_NATIVE=ON"  # Enable AVX/AVX2 optimizations for CPU layers
          ];
          preConfigure = ''
            export NIX_ENFORCE_NO_NATIVE=0
            ${oldAttrs.preConfigure or ""}
          '';
        });
      })
    ];

    # llama.cpp server service
    systemd.services.llama-cpp = {
      description = "llama.cpp Server with ROCm support";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        # ROCm environment variables for RX 6800 (RDNA 2 / gfx1030)
        HSA_OVERRIDE_GFX_VERSION = "10.3.0";
        ROCM_PATH = "${pkgs.rocmPackages.rocm-runtime}";
        HIP_VISIBLE_DEVICES = "0";
        GPU_MAX_HW_QUEUES = "2";

        # Library paths for ROCm
        LD_LIBRARY_PATH = "/run/opengl-driver/lib";
      };

      serviceConfig = {
        ExecStart = ''
          ${pkgs.llama-cpp-rocm}/bin/llama-server \
            ${lib.escapeShellArgs routerArgs}
        '';

        Restart = "always";
        RestartSec = 5;
        User = "llama-cpp";
        Group = "llama-cpp";
        SupplementaryGroups = [ "video" "render" ];

        # Create model directory
        StateDirectory = "llama-cpp";
        StateDirectoryMode = "0755";
      };
    };

    # Create user for llama-cpp
    users.users.llama-cpp = {
      isSystemUser = true;
      group = "llama-cpp";
      extraGroups = [ "video" "render" ];
      home = "/var/lib/llama-cpp";
      createHome = true;
    };

    users.groups.llama-cpp = {};

    # Firewall
    networking.firewall.allowedTCPPorts = [ 11434 ];

    # System packages
    environment.systemPackages = with pkgs; [
      llama-cpp-rocm
      rocmPackages.rocm-runtime
    ];
  };
}
