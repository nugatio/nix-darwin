# nb@2026.05.30

{ pkgs, lib, inputs, ... }:
{
  home.packages = with pkgs; [

    # ////////// NIX TOOLING //////////

    nh
    nix-output-monitor
    nvd
    nix-index
    nix-your-shell
    inputs.cachix.packages.${pkgs.system}.cachix
    inputs.devenv.packages.${pkgs.system}.devenv
    comma
    bun


    # ////////// AI //////////

    inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-cli
    gemini-cli
    claude-code
    (aider-chat.overrideAttrs (oldAttrs: {
      doCheck = false;
    }))
    fabric-ai
    aichat
    (goose-cli.overrideAttrs (oldAttrs: {
      doCheck = false;
    }))
    opencode
    crush
    codex
    python3Packages.llm
    (writeShellScriptBin "feynman" ''
      exec ${bun}/bin/bun x @companion-ai/feynman@0.2.40 "$@"
    '')


    # ////////// TERMINAL //////////

    zjstatus
    micro


    # ////////// MISC //////////

    tectonic
    uv


    # ////////// CLI //////////

    sd # sed
    procs # ps
    dust # du
    duf # df
    rm-improved # rm
    xcp # cp
    choose # cut/awk
    ouch # unzip/tar
    hyperfine # benchmarking
    tokei # code statistics
    moor
    tlrc # tldr client
    fastfetch


    # ////////// NETWORK & MONITORING //////////

    xh # curl/wget (HTTP client)
    doggo # dig (DNS)
    gping # ping (graph)
    trippy # mtr (network diagnostics)
    bandwhich # network usage monitor


    # ////////// GIT & WORKFLOWS //////////

    just # command runner
    onefetch # git repo summary
    git-absorb


    # ////////// CONTAINER & CLUSTER MANAGEMENT //////////

    lazydocker
    k9s
    kubectl


    # ////////// DATA PROCESSING & SECRETS //////////

    jaq # jq clone
    yq-go # yaml processor
    usql # universal SQL client
    age # file encryption
  ];
}
