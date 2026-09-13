# nb@2026.05.30

{ ... }: {
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    taps = [
      {
        name = "nikitabobko/tap";
        trusted = true;
      }
    ];
    casks = [
      "adguard"
      "aerospace"
      "affinity"
      "aldente"
      "alt-tab"
      "anki"
      "antigravity"
      "balenaetcher"
      "bartender"
      "betterdisplay"
      "bettertouchtool"
      "bitwarden"
      "caffeine"
      "chatgpt"
      "claude"
      "codex"
      "daisydisk"
      "font-sf-pro"
      "ghostty"
      "google-chrome"
      "google-gemini"
      "granola"
      "hammerspoon"
      "jetbrains-toolbox"
      "lark"
      "legcord"
      "linear"
      "linearmouse"
      "numi"
      "mactex"
      "microsoft-word"
      "microsoft-powerpoint"
      "microsoft-excel"
      "microsoft-teams"
      "mochi"
      "motu-m-series"
      "mullvad-vpn"
      "obsidian"
      "orbstack"
      "positron"
      "raycast"
      "skim"
      "spotify"
      "synology-drive"
      "tailscale-app"
      "tradingview"
      "tuta-mail"
      "utm"
      "visual-studio-code"
      "wezterm"
      "zed"
      "zotero"
    ];

    masApps = {
      # "Things 3" = 904280696;
      # "Infuse" = 1136220934;
      # "Dropover - Easier Drag & Drop" = 1355679052;
      # "Flow: Pomodoro & Study Timer" = 1423210932;
      # "NextDNS" = 1464122853;
      # "Perplexity: Ask Anything" = 6714467650;
      # "reMarkable desktop" = 1276493162;
    };
  };
}
