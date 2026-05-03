# System-level Hyprland, greetd, portals, and Wayland session configuration.

{ pkgs, lib, ... }:
let
  greetdPath = lib.makeBinPath [ pkgs.regreet ];
  greetdCommand =
    "${pkgs.bash}/bin/bash -lc 'export PATH=${greetdPath}:$PATH; exec ${pkgs.hyprland}/bin/Hyprland --config /etc/greetd/hyprland.conf'";
in
{
  # Enable Hyprland compositor
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Disable GNOME/GDM completely
  services.displayManager.gdm.enable = lib.mkForce false;
  services.desktopManager.gnome.enable = lib.mkForce false;

  # Ensure greetd/regreet preselect a real desktop session instead of falling
  # back to the user's shell when no previous session choice is remembered.
  services.displayManager.defaultSession = "hyprland";

  # Export Hyprland's desktop entry to the system profile so greeters can
  # enumerate it from share/wayland-sessions.
  services.displayManager.sessionPackages = [ pkgs.hyprland ];

  # greetd display manager with regreet (runs under Hyprland)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = greetdCommand;
        user = "greeter";
      };
    };
  };

  # Hyprland config for greeter session
  environment.etc."greetd/hyprland.conf".source = ./hypr/greetd/hyprland.conf;

  # regreet configuration (stylix handles GTK theming)
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        fit = "Cover";
      };
    };
  };

  # XDG portal for screen sharing, file dialogs, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.hyprland.default = [
      "hyprland"
      "gtk"
    ];
  };

  # Security - polkit for GUI authentication prompts
  security.polkit.enable = true;
  systemd.user.services.lxqt-policykit-agent = {
    description = "LXQt PolicyKit Agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # System packages for Hyprland environment
  # Note: noctalia-shell provides: bar, notifications, launcher, wallpaper, idle/lock
  environment.systemPackages = with pkgs; [
    # libnotify still needed for notify-send from scripts
    libnotify

    # Screenshots
    grim
    slurp

    # Clipboard
    wl-clipboard
    cliphist

    # System controls
    brightnessctl
    playerctl

    # Audio control
    pavucontrol

    # File manager
    xfce.thunar
    xfce.thunar-volman
    papirus-icon-theme

    # Archive manager
    file-roller
  ];

  # Enable necessary services
  services.gvfs.enable = true; # For nautilus trash, network mounts

  # Session environment variables
  environment.sessionVariables = {
    # Hint electron apps to use Wayland
    NIXOS_OZONE_WL = "1";
    # XDG current desktop for portal detection
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };
}
