{ pkgs, ... }:
{
  home.packages = [
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

  home.stateVersion = "25.11";
}
