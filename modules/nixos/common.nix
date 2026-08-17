# Shared NixOS system settings that are not tied to a specific user or desktop environment.

{
  pkgs,
  lib,
  ...
}:
{
  # Nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.warn-dirty = false;
  nix.optimise.automatic = true;

  # Garbage collection options
  nix.gc.automatic = true;
  nix.gc.dates = "weekly"; # How often garbage collection runs
  nix.gc.options = "--delete-older-than 7d"; # Auto removes old generations

  # Bootloader
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    libratbag # Backend for piper mouse config
  ];

  # Name resolution
  services.resolved.enable = true;

  # Audio related
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Other services
  services.ratbagd.enable = true;
  services.openssh.enable = true;
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  # Networking and security
  networking.networkmanager.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Containers
  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";

  # Locales
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # NixOS-specific zsh configuration
  programs.zsh.enable = true;
}
