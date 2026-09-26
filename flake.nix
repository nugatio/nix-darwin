# nb@2026.05.30

{
  description = "NB macOS";


  # ////////// INPUTS //////////

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    zjstatus.url = "github:dj95/zjstatus";
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    # Upstream flakes: their builds are in devenv.cachix.org / cachix.cachix.org.
    # Do NOT add inputs.nixpkgs.follows here, it would change the store paths and miss the cache.
    devenv.url = "github:cachix/devenv/v2.4.0";
    cachix.url = "github:cachix/cachix";
  };


  # ////////// OUTPUTS //////////

  outputs = { self, darwin, nixpkgs, home-manager, sops-nix, rust-overlay, determinate, nix-homebrew, zjstatus, antigravity-nix, nixpkgs-firefox-darwin, ... }@inputs:
    let
      system = "aarch64-darwin";
      primaryUser = "nb";
      deviceName = "macbookpro";
    in
    {
      darwinConfigurations.${deviceName} = darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs self primaryUser; };
        modules = [
          ./darwin/default.nix
        ];
      };
    };
}
