# Home Manager configuration for a GNOME-based desktop session.

{ pkgs, ... }:
{
  xdg.desktopEntries."trash" = {
    name = "Trash";
    comment = "View and restore deleted files";
    icon = "user-trash";
    exec = "${pkgs.nautilus}/bin/nautilus trash:///";
    terminal = false;
    type = "Application";
    categories = [
      "Utility"
      "Filesystem"
    ];
  };

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "google-chrome.desktop"
        "brave-browser.desktop"
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "jellyfin-media-player.desktop"
        "com.mitchellh.ghostty.desktop"
        "steam.desktop"
        "obsidian.desktop"
        "trash.desktop"
      ];
      disable-user-extensions = false;
      enabled-extensions = [ "dash-to-panel@jderose9.github.com" ];
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      animate-appicon-hover = true;
      animate-appicon-hover-animation-type = "SIMPLE";
      dot-position = "BOTTOM";
      dot-style-focused = "SQUARES";
      dot-style-unfocused = "SQUARES";
    };

    "org/gnome/desktop/interface" = {
      clock-format = "12h";
    };
  };
}
