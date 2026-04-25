# Shared Home Manager builder for NixOS and Darwin hosts.
#
# This file assembles the common Home Manager configuration, platform-specific
# Home Manager module imports, and host-specific home configuration into the
# exported `mkHomeManagerConfig` constructor.

{
  nixpkgs,
  nixpkgs-unstable,
  inputs,
  noctalia,
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
  mkHomeManagerConfig =
    {
      platform,
      hostName,
      system,
      username ? defaultUsername,
      extraOverlays ? [ ],
      extraHomeManagerModules ? [ ],
      hostsRoot ? defaultHostsRoot,
      dotfilesSrc ? defaultDotfilesSrc,
    }:
    let
      homeDirectory = if platform == "nixos" then /home/${username} else /Users/${username};
    in
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.sharedModules = extraHomeManagerModules;
      home-manager.users.${username} = {
        imports = [
          (self + "/modules/shared/home.nix")
        ]
        ++ [
          (self + "/modules/${platform}/home.nix")
          (hostsRoot + "/${platform}/${hostName}/home.nix")
        ];

        home = {
          inherit username;
          homeDirectory = nixpkgs.lib.mkForce homeDirectory;
        };
      };
      home-manager.extraSpecialArgs = {
        inherit
          username
          noctalia
          extraOverlays
          extraHomeManagerModules
          hostsRoot
          dotfilesSrc
          ;
        pkgs-unstable = commonLib.mkUnstablePkgs system;
      };
    };
}
