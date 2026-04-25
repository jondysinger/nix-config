# Darwin-specific builder for creating system configurations.
#
# This file assembles the shared base modules, Darwin platform modules,
# Home Manager wiring, and host-specific Darwin configuration into a single
# exported `mkDarwinConfiguration` constructor.

{
  nixpkgs,
  nixpkgs-unstable,
  inputs,
  nix-darwin,
  home-manager,
  stylix,
  mkHomeManagerConfig,
  mkSharedBaseModules,
  mkDarwinBaseModules,
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
  mkDarwinConfiguration =
    {
      hostName,
      system ? "aarch64-darwin",
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
    nix-darwin.lib.darwinSystem {
      inherit system specialArgs;

      modules = [
        { nixpkgs.overlays = extraOverlays; }
      ]
      ++ mkSharedBaseModules { }
      ++ mkDarwinBaseModules { }
      ++ [
        (import (self + "/modules/darwin/users.nix") {
          inherit username;
          lib = nixpkgs.lib;
        })

        home-manager.darwinModules.home-manager
        (mkHomeManagerConfig {
          platform = "darwin";
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

        (hostsRoot + "/darwin/${hostName}/configuration.nix")
        stylix.darwinModules.stylix
      ];
    };
}
