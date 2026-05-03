# System-level GNOME session configuration built on the shared GUI baseline.

{ lib, pkgs, ... }:
{
  # GNOME owns the display manager; disable the Hyprland greeter stack.
  services.greetd.enable = lib.mkForce false;
  programs.regreet.enable = lib.mkForce false;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.defaultSession = "gnome";

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.gnome.default = [ "gtk" ];
  };

  security.polkit.enable = true;
  services.gvfs.enable = true; # Trash, mounts, and Nautilus integration.

  environment.systemPackages = with pkgs; [
    gnomeExtensions.dash-to-panel
    nautilus
    gnome-tweaks
    gnome-extension-manager
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_CURRENT_DESKTOP = "GNOME";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "gnome";
  };
}
