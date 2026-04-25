# Host discovery and configuration assembly helpers.
#
# This file resolves the effective host inventory path, lists host names for a
# given platform, and assembles host-specific NixOS or Darwin configurations
# through the exported `mkConfigurationsFromHosts` helper.

{
  nixpkgs,
  defaultUsername,
  defaultHostsRoot,
  defaultDotfilesSrc,
  listHostNames ? null,
  mkNixosConfiguration,
  mkDarwinConfiguration,
}:
let
  # Use a caller-provided host lister when present; otherwise derive host names
  # by listing platform-specific subdirectories under the resolved hosts root.
  resolvedListHostNames =
    if listHostNames != null then
      listHostNames
    else
      {
        platform,
        hostsRoot ? defaultHostsRoot,
      }:
      let
        platformHostsPath = hostsRoot + "/${platform}";
      in
      if builtins.pathExists platformHostsPath then
        builtins.attrNames (
          nixpkgs.lib.filterAttrs (_: type: type == "directory") (builtins.readDir platformHostsPath)
        )
      else
        [ ];
in
{
  listHostNames = resolvedListHostNames;

  mkConfigurationsFromHosts =
    {
      platform,
      username ? defaultUsername,
      extraOverlays ? [ ],
      extraHomeManagerModules ? [ ],
      hostsRoot ? null,
      hostNames ? null,
      dotfilesSrc ? defaultDotfilesSrc,
    }:
    let
      resolvedHostsRoot = if hostsRoot != null then hostsRoot else defaultHostsRoot;
      resolvedHostNames =
        if hostNames != null then
          hostNames
        else
          resolvedListHostNames {
            inherit platform;
            hostsRoot = resolvedHostsRoot;
          };
    in
    # Build an attrset of concrete host configurations by mapping each resolved
    # host name through the appropriate platform-specific builder.
    builtins.listToAttrs (
      map (hostName: {
        name = hostName;
        value =
          if platform == "nixos" then
            mkNixosConfiguration {
              inherit
                hostName
                username
                extraOverlays
                extraHomeManagerModules
                dotfilesSrc
                ;
              hostsRoot = resolvedHostsRoot;
            }
          else
            mkDarwinConfiguration {
              inherit
                hostName
                username
                extraOverlays
                extraHomeManagerModules
                dotfilesSrc
                ;
              hostsRoot = resolvedHostsRoot;
            };
      }) resolvedHostNames
    );
}
