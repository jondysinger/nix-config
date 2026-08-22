# Shared NixOS Home Manager configuration.

{
  pkgs,
  ...
}:
{
  home.packages = [
    # Hardware and system inspection tools
    pkgs.usbutils
    pkgs.pciutils
    pkgs.mesa-demos
    pkgs.gdu
    pkgs.smartmontools
    pkgs.lm_sensors

    # Nix and editor tooling
    pkgs.lua-language-server
    pkgs.nil
    pkgs.nixfmt
    pkgs.stylua
    pkgs.tree-sitter

    # Media tooling
    pkgs.mkvtoolnix

    # Rust toolchain
    pkgs.rustc
    pkgs.cargo
    pkgs.rust-analyzer
    pkgs.clippy
    pkgs.rustfmt
  ];

  imports = [
    ./vscodium.nix
  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [ "--force-device-scale-factor=1.20" ];
  };

  programs.zsh.shellAliases = {
    norb = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
  };
}
