# Shared helpers used by the platform-specific configuration builders.
#
# This file defines small cross-cutting utilities that are consumed by both the
# NixOS and Darwin builder libraries.

{
  self,
  nixpkgs-unstable,
  inputs,
  userDescription,
  defaultUsername,
  defaultHostsRoot,
}:
let
  mkUnstablePkgs =
    system:
    import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
in
{
  inherit mkUnstablePkgs;

  mkSpecialArgs =
    {
      system,
      hostName,
      username ? defaultUsername,
      extraOverlays ? [ ],
      extraHomeManagerModules ? [ ],
      hostsRoot ? defaultHostsRoot,
    }:
    {
      inherit
        inputs
        hostName
        username
        userDescription
        extraOverlays
        extraHomeManagerModules
        hostsRoot
        ;
      mediaDir = self + "/media";
      pkgs-unstable = mkUnstablePkgs system;
    };
}
