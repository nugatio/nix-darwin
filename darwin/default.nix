# nb@2026.05.30

{ pkgs, inputs, self, primaryUser, ... }: {
  imports = [
    ./settings.nix
    ./homebrew.nix
    inputs.determinate.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.sops-nix.darwinModules.sops
  ];


  # ////////// SECRETS & SECURITY //////////

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/Users/${primaryUser}/.config/sops/age/keys.txt";
  };

  security = {
    pam.services.sudo_local.touchIdAuth = true;
  };


  # ////////// NIX //////////

  # Determinate Nix owns /etc/nix/nix.conf and forces nix.enable = false, so
  # nix.settings is ignored; custom settings must go through determinateNix.
  determinateNix.customSettings = {
    trusted-users = [
      "root"
      "@admin"
      primaryUser
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
      "https://cachix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoUckM="
    ];
  };


  # ////////// NIXPKGS //////////

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        zjstatus = inputs.zjstatus.packages.${prev.stdenv.hostPlatform.system}.default;
      })
      inputs.rust-overlay.overlays.default
      inputs.nixpkgs-firefox-darwin.overlay
      (final: prev: {
        librewolf = prev.librewolf.overrideAttrs (old: {}) // {
          override = final.lib.setFunctionArgs (args:
            let
              newArgs = if builtins.isFunction args then args {} else args;
              cfg = newArgs.cfg or {};
              policies = cfg.policies or {};
              extraPolicies = newArgs.extraPolicies or {};
              allPolicies = policies // extraPolicies;
            in
            if allPolicies == {} then
              prev.librewolf
            else
              final.stdenv.mkDerivation {
                name = (prev.librewolf.name or "librewolf") + "-wrapped";
                buildInputs = [ prev.librewolf ];
                passAsFile = [ "policiesJson" ];
                policiesJson = builtins.toJSON { policies = allPolicies; };
                buildCommand = ''
                  mkdir -p $out/Applications
                  cp -R ${prev.librewolf}/Applications/LibreWolf.app $out/Applications/LibreWolf.app
                  chmod -R u+w $out/Applications/LibreWolf.app
                  
                  mkdir -p $out/Applications/LibreWolf.app/Contents/Resources/distribution
                  cat $policiesJsonPath > $out/Applications/LibreWolf.app/Contents/Resources/distribution/policies.json
                  
                  if [ -d ${prev.librewolf}/bin ]; then
                    mkdir -p $out/bin
                    ln -s $out/Applications/LibreWolf.app/Contents/MacOS/librewolf $out/bin/librewolf
                  fi
                '';
                meta = prev.librewolf.meta or {};
              }) { cfg = true; extraPolicies = true; };
        };
      })
      (final: prev: {
        kvazaar = prev.kvazaar.overrideAttrs (oldAttrs: {
          doCheck = false;
        });
        chromaprint = prev.chromaprint.overrideAttrs (oldAttrs: {
          doCheck = false;
        });
      })
    ];
  };


  # ////////// HOMEBREW //////////

  nix-homebrew = {
    enableRosetta = true;
    user = primaryUser;
    enable = true;
    autoMigrate = true;
    enableFishIntegration = true;
  };


  # ////////// HOME MANAGER //////////

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${primaryUser} = {
      imports = [
        ../home
      ];
      home.file.".hushlogin".text = "";
    };
    extraSpecialArgs = {
      inherit inputs self primaryUser;
    };
  };


  # ////////// SYSTEM & USER //////////

  system = {
    primaryUser = primaryUser;
  };

  programs = {
    fish.enable = true;
  };

  users.users.${primaryUser} = {
    name = primaryUser;
    home = "/Users/${primaryUser}";
    shell = pkgs.fish;
  };

  environment = {
    systemPackages = [ pkgs.git pkgs.fish pkgs.nushell ];
    shells = [ pkgs.fish pkgs.nushell ];
    systemPath = [
      "/opt/homebrew/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
