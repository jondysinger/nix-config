# Declares the primary NixOS user account and shared group memberships.

{ username, userDescription, ... }:
{ lib, pkgs, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    description = lib.mkDefault userDescription;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "video"
      "render"
    ];
    shell = pkgs.zsh;
  };
}
