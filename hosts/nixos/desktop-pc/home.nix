{ pkgs, ... }:
{
  imports = [
    ../../../modules/nixos/home-hyprland.nix
  ];

  home.packages = [
    pkgs.mangohud
    pkgs.sunshine
  ];

  # Sunshine (user service)
  # Managed here to ensure it runs with a user session (needed for Wayland capture).
  xdg.configFile."sunshine/sunshine.conf".text = ''
    encoder=vaapi
    min_log_level=info
    port=47989
  '';

  systemd.user.services.sunshine = {
    Unit = {
      Description = "Self-hosted game stream host for Moonlight";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "/run/wrappers/bin/sunshine %h/.config/sunshine/sunshine.conf";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # desktop-pc specific Hyprland config (overrides default from nixos/home.nix)
  xdg.configFile."hypr/monitors.conf" = {
    text = builtins.readFile ./hypr/monitors.conf;
    force = true;
  };

  # Minimal, useful MangoHud overlay. Toggle with F12.
  xdg.configFile."MangoHud/MangoHud.conf".text =
    "	fps\n	frametime\n	gpu_name\n	cpu_stats\n	gpu_temp\n	vram\n	ram\n	gamemode\n	position=top-right\n	font_size=18\n	toggle_hud=F12\n";

  home.stateVersion = "25.11";
}
