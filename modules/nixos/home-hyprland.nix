# Home Manager configuration for a Hyprland-based desktop session.

{
  pkgs,
  noctalia,
  ...
}:
{
  imports = [
    noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    plugins = {
      version = 2;
      sources = [
        {
          enabled = true;
          name = "Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        hostname = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
    };
    settings = {
      bar = {
        position = "top";
        density = "spacious";
        widgets = {
          left = [
            { id = "Launcher"; }
            { id = "plugin:hostname"; }
            { id = "SystemMonitor"; }
            { id = "MediaMini"; }
          ];
          center = [
            {
              id = "Workspace";
              labelMode = "name";
              characterCount = 8;
              showLabelsOnlyWhenOccupied = false;
              hideUnoccupied = false;
            }
          ];
          right = [
            {
              id = "VPN";
              displayMode = "alwaysShow";
            }
            {
              formatHorizontal = "MMM dd, h:mm ap";
              id = "Clock";
            }
            { id = "Tray"; }
            { id = "NotificationHistory"; }
            {
              id = "Battery";
              displayMode = "graphic";
            }
            { id = "Volume"; }
            { id = "ControlCenter"; }
          ];
        };
      };

      colorSchemes = {
        predefinedScheme = "Rosepine";
      };

      location = {
        use12hourFormat = true;
        useFahrenheit = true;
      };

      idle = {
        timeout = 300;
        lockTimeout = 600;
      };

      notifications = {
        position = "top-right";
        timeout = 5000;
      };

      appLauncher = {
        showIcons = true;
        showSearch = true;
      };

      wallpaper = {
        enable = true;
        fillMode = "fill";
      };
    };
  };

  # Hyprland configuration files (Nix-managed)
  xdg.configFile = {
    "noctalia/plugins/hostname/manifest.json".source = ./hypr/noctalia/plugins/hostname/manifest.json;
    "noctalia/plugins/hostname/HostnameWidget.qml".source =
      ./hypr/noctalia/plugins/hostname/HostnameWidget.qml;
    "hypr/hyprland.conf".text = builtins.readFile ./hypr/hyprland.conf;
    "hypr/keybinds.conf".text = builtins.readFile ./hypr/keybinds.conf;
    "hypr/autostart.conf".text = builtins.readFile ./hypr/autostart.conf;
    # Per-host overrides (empty by default)
    "hypr/autostart.local.conf".text = "";
    "hypr/monitors.conf" = {
      text = builtins.readFile ./hypr/monitors-default.conf;
      # Allow host-specific configs to override
      force = true;
    };
  };

  # Rose Pine cursor theme
  home.pointerCursor = {
    name = "rose-pine-hyprcursor";
    size = 24;
    package = pkgs.rose-pine-hyprcursor;
    gtk.enable = true;
  };

  # Trash entry (so we can add to favorites)
  xdg.desktopEntries."trash" = {
    name = "Trash";
    comment = "View and restore deleted files";
    icon = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/48x48/places/user-trash.svg";
    exec = "${pkgs.xfce.thunar}/bin/thunar trash:///";
    terminal = false;
    type = "Application";
    categories = [
      "Utility"
      "Filesystem"
    ];
  };
}
