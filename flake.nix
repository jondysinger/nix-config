# Shared flake for reusable NixOS and nix-darwin configuration logic.
#
# This file declares the top-level flake inputs, default repository paths, and
# the exported builder API used to assemble host configurations. It exposes the
# reusable configuration constructors and populates `nixosConfigurations` and
# `darwinConfigurations` from the checked-in `hosts/` tree when this repository
# is used standalone.
#
# In the split-repo model, a private flake can import this one and reuse the
# same builders but override the `hostsRoot` to leverage externally managed
# host declarations and override `dotfilesSrc` to leverage externally managed
# dotfile configurations.

{
  description = "My NixOS and macOS (nix-darwin) configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nix-darwin,
      stylix,
      noctalia,
      ...
    }:
    let
      # Default user (change for your system)
      defaultUsername = "user";
      userDescription = "Primary User";

      # Default directory locations for option overrides
      defaultHostsRoot = self + "/hosts";
      defaultDotfilesSrc = self + "/modules/shared/dotfiles";

      # Base module groupings
      mkSharedBaseModules =
        { }:
        [
          (self + "/modules/shared/common.nix")
          (self + "/modules/shared/desktop.nix")
        ];
      mkNixosBaseModules =
        { }:
        [
          (self + "/modules/nixos/common.nix")
        ];
      mkDarwinBaseModules =
        { }:
        [
          (self + "/modules/darwin/common.nix")
          (self + "/modules/darwin/desktop.nix")
        ];

      # Lib helpers for making configurations
      homeLib = import ./lib/home.nix {
        inherit
          nixpkgs
          nixpkgs-unstable
          inputs
          noctalia
          userDescription
          defaultUsername
          self
          defaultHostsRoot
          defaultDotfilesSrc
          ;
      };
      inherit (homeLib) mkHomeManagerConfig;
      nixosLib = import ./lib/nixos.nix {
        inherit
          nixpkgs
          nixpkgs-unstable
          inputs
          home-manager
          stylix
          mkHomeManagerConfig
          mkSharedBaseModules
          mkNixosBaseModules
          userDescription
          defaultUsername
          self
          defaultHostsRoot
          defaultDotfilesSrc
          ;
      };
      inherit (nixosLib) mkNixosConfiguration;
      darwinLib = import ./lib/darwin.nix {
        inherit
          nixpkgs
          nixpkgs-unstable
          inputs
          nix-darwin
          home-manager
          stylix
          mkHomeManagerConfig
          mkSharedBaseModules
          mkDarwinBaseModules
          userDescription
          defaultUsername
          self
          defaultHostsRoot
          defaultDotfilesSrc
          ;
      };
      inherit (darwinLib) mkDarwinConfiguration;
      hostsLib = import ./lib/hosts.nix {
        inherit
          nixpkgs
          defaultUsername
          defaultHostsRoot
          defaultDotfilesSrc
          mkNixosConfiguration
          mkDarwinConfiguration
          ;
      };
      inherit (hostsLib)
        listHostNames
        mkConfigurationsFromHosts
        ;

    in
    {
      # Reusable API surface. Callers importing this flake should generally use
      # these builders directly.
      lib = {
        inherit
          listHostNames
          mkHomeManagerConfig
          mkNixosConfiguration
          mkDarwinConfiguration
          mkConfigurationsFromHosts
          ;
        modules = {
          shared = {
            base = mkSharedBaseModules { };
            mkBase = mkSharedBaseModules;
          };
          nixos = {
            base = mkNixosBaseModules { };
            mkBase = mkNixosBaseModules;
          };
          darwin = {
            base = mkDarwinBaseModules { };
            mkBase = mkDarwinBaseModules;
          };
        };
      };
    }
    # Add this repo's concrete host outputs for standalone/direct use. Callers
    # importing `lib.*` builders do not need this layer.
    // {
      nixosConfigurations = mkConfigurationsFromHosts {
        platform = "nixos";
      };
      darwinConfigurations = mkConfigurationsFromHosts {
        platform = "darwin";
      };
    };
}
