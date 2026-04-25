# Shared system-level packages and settings that work across both NixOS and
# Darwin hosts.

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Build toolchain
    gcc
    gnumake

    # Container runtime tools
    podman
    podman-compose

    # Theme related
    base16-schemes # Used for stylix color scheme
  ];

  nixpkgs.config.allowUnfree = true;
}
