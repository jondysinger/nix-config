# This module declares macOS-specific common settings via nix-darwin

{ pkgs, ... }:
{
  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;

  environment.systemPackages = with pkgs; [
    # Formatters
    nil
    nixfmt-rfc-style
    stylua
  ];

  fonts.packages = with pkgs; [
    vista-fonts
    nerd-fonts.jetbrains-mono
  ];
}
