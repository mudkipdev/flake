{ config, pkgs, lib, ... }:

let
  modelsDirectory = "/var/lib/llama-cpp/models";
  # Use a non-cache directory to avoid llama.cpp auto-discovering models
  cacheDirectory = "/var/lib/llama-cpp/downloads";
  # Keep router in "presets-only" behavior (no stray GGUF auto-discovery) by
  # pointing --models-dir at an empty directory while still using --models-preset.
  routerModelsDirectory = "/var/lib/llama-cpp/router-models";

  models = {
    "glm-4.5-air:106b" = import ./models/glm-4.5-air.nix { inherit modelsDirectory; };
    "qwen3-vl:30b" = import ./models/qwen3-vl.nix { inherit modelsDirectory cacheDirectory; };
    "gemma3:27b" = import ./models/gemma3-27b.nix { inherit modelsDirectory cacheDirectory; };
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
    lib.generators.toINIWithGlobalSection { } {
      globalSection = { version = 1; };
      sections = presetModels;
    }
  );

  routerArgs = [
    "--host"
    "0.0.0.0"
    "--port"
    "11434"
    "--models-dir"
    routerModelsDirectory
    "--models-max"
    (builtins.toString config.services.llama-cpp-router.modelsMax)
    "--models-preset"
    modelsPresetFile
  ];

  downloadModelsScript = pkgs.writeShellScript "llama-cpp-download-models" ''
    set -euo pipefail

    download() {
      local url="$1"
      local dst="$2"
      local expected_size="$3"

      mkdir -p "$(dirname "$dst")"

      # If already complete, do nothing.
      if [ -f "$dst" ]; then
        local current_size
        current_size="$(stat -c %s "$dst" || echo 0)"
        if [ "$current_size" = "$expected_size" ]; then
          return 0
        fi
      fi

      ${pkgs.curl}/bin/curl \
        -L \
        --fail \
        --retry 999 \
        --retry-all-errors \
        --retry-delay 10 \
        -C - \
        -o "$dst" \
        "$url"

      local final_size
      final_size="$(stat -c %s "$dst" || echo 0)"
      if [ "$final_size" != "$expected_size" ]; then
        echo "download size mismatch for $dst: got $final_size, expected $expected_size" >&2
        return 1
      fi
    }

    while true; do
      all_ok=1

      # Qwen3-VL 30B A3B (Q4_K_M)
      if ! download \
        "https://huggingface.co/unsloth/Qwen3-VL-30B-A3B-Instruct-GGUF/resolve/main/Qwen3-VL-30B-A3B-Instruct-Q4_K_M.gguf" \
        "${cacheDirectory}/Qwen3-VL-30B-A3B-Instruct-Q4_K_M.gguf" \
        "30532122624"; then
        all_ok=0
      fi

      # Gemma 3 27B IT (Q4_K_M)
      if ! download \
        "https://huggingface.co/unsloth/gemma-3-27b-it-GGUF/resolve/main/gemma-3-27b-it-Q4_K_M.gguf" \
        "${cacheDirectory}/gemma-3-27b-it-Q4_K_M.gguf" \
        "27009346304"; then
        all_ok=0
      fi

      if [ "$all_ok" -eq 1 ]; then
        exit 0
      fi

      echo "One or more downloads failed; retrying in 30 seconds..." >&2
      sleep 30
    done
  '';
in {
  options.services.llama-cpp-router = {
    defaultModel = lib.mkOption {
      type = lib.types.enum (builtins.attrNames models);
      default = "glm-4.5-air:106b";
      description = "Model preset to load on startup for the llama.cpp router server.";
    };
    modelsMax = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Maximum number of models to keep loaded simultaneously.";
    };
  };

  config = {
    systemd.tmpfiles.rules = [
      "d ${routerModelsDirectory} 0755 llama-cpp llama-cpp - -"
      "d ${modelsDirectory} 0755 llama-cpp llama-cpp - -"
      "d ${cacheDirectory} 0755 llama-cpp llama-cpp - -"
    ];

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

    # Resumable downloads for the HF-backed models; runs once after activation and
    # keeps retrying until the files are complete.
    systemd.services.llama-cpp-download-models = {
      description = "Download llama.cpp models (resumable)";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        User = "llama-cpp";
        Group = "llama-cpp";
        WorkingDirectory = "/var/lib/llama-cpp";
        ExecStart = downloadModelsScript;
        Restart = "always";
        RestartSec = 30;
        StartLimitIntervalSec = 0;
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
