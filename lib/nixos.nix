# NixOS-specific builder for creating system configurations.
#
# This file assembles the shared base modules, NixOS platform modules,
# Home Manager wiring, and host-specific NixOS configuration into a single
# exported `mkNixosConfiguration` constructor.

{
  nixpkgs,
  nixpkgs-unstable,
  inputs,
  home-manager,
  stylix,
  mkHomeManagerConfig,
  mkSharedBaseModules,
  mkNixosBaseModules,
  userDescription,
  defaultUsername,
  self,
  defaultHostsRoot,
  defaultDotfilesSrc,
}:
let
  commonLib = import ./common.nix {
    inherit
      self
      nixpkgs-unstable
      inputs
      userDescription
      defaultUsername
      defaultHostsRoot
      ;
  };
in
{
  mkNixosConfiguration =
    {
      hostName,
      system ? "x86_64-linux",
      username ? "user",
      extraOverlays ? [ ],
      extraHomeManagerModules ? [ ],
      hostsRoot ? defaultHostsRoot,
      dotfilesSrc ? defaultDotfilesSrc,
    }:
    let
      specialArgs = commonLib.mkSpecialArgs {
        inherit
          system
          hostName
          username
          extraOverlays
          extraHomeManagerModules
          hostsRoot
          ;
      };
    in
    nixpkgs.lib.nixosSystem {
      inherit system specialArgs;

      modules = [
        { nixpkgs.overlays = extraOverlays; }
      ]
      ++ mkSharedBaseModules { }
      ++ mkNixosBaseModules { }
      ++ [
        (import (self + "/modules/nixos/users.nix") {
          inherit username userDescription;
        })

        home-manager.nixosModules.home-manager
        (mkHomeManagerConfig {
          platform = "nixos";
          inherit
            hostName
            system
            username
            extraOverlays
            extraHomeManagerModules
            hostsRoot
            dotfilesSrc
            ;
        })

        (hostsRoot + "/nixos/${hostName}/configuration.nix")
        (hostsRoot + "/nixos/${hostName}/hardware-configuration.nix")
        stylix.nixosModules.stylix
      ];
    };
}
