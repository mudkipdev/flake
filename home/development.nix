{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    claude-code
    jetbrains.idea-community
    godot_4
    docker
    docker-compose
    jdk21
    pnpm
    uv
    python3
    go

    (rust-bin.nightly.latest.default.override {
      extensions = [ "rust-src" "rust-analyzer" "clippy" "rustfmt" ];
    })

    # Note: Install these plugins manually after opening IntelliJ:
    # - WakaTime (Plugin ID: 7425)
    # - GitHub Theme (Plugin ID: 15418) 
    # - Classic UI (Plugin ID: 24468)
  ];

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Language Support
        rust-lang.rust-analyzer
        astro-build.astro-vscode
        svelte.svelte-vscode
        jnoortheen.nix-ide
        ms-python.python
        ms-python.vscode-pylance
        golang.go

        # Miscellaneous
        github.github-vscode-theme
        wakatime.vscode-wakatime
      ];

      userSettings = {
        "workbench.startupEditor" = "none";
        "chat.disableAIFeatures" = "true";
        "workbench.colorTheme" = "GitHub Dark Default";
        "python.analysis.typeCheckingMode" = "strict";
      };
    };
  };
}
