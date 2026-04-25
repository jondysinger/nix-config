# Declares the primary user and shared macOS system defaults (Finder, keyboard repeat)

{ lib, username, ... }:
{
  # Since we have to build as root, we need to tell nix-darwin about the primary user
  users.users.${username} = {
    home = "/Users/${username}";
  };
  system.primaryUser = username;

  system.defaults = {
    finder = {
      AppleShowAllExtensions = lib.mkDefault true;
    };

    NSGlobalDomain = {
      InitialKeyRepeat = lib.mkDefault 15;
      KeyRepeat = lib.mkDefault 2;
    };
  };
}
