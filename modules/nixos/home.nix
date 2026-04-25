# NixOS-specific home-manager configuration for Noctalia, Hyprland, and desktop UX.

{
  pkgs,
  noctalia,
  ...
}:
{
  imports = [
    noctalia.homeModules.default
  ];

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
    pkgs.nixfmt-rfc-style
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

  # Brave with scaling
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [ "--force-device-scale-factor=1.20" ];
  };

  # NixOS-specific zsh configuration
  programs.zsh.shellAliases = {
    norb = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
  };

  # Hyprland configuration files (Nix-managed)
  xdg.configFile = {
    "noctalia/plugins/hostname/manifest.json".source = ./noctalia/plugins/hostname/manifest.json;
    "noctalia/plugins/hostname/HostnameWidget.qml".source =
      ./noctalia/plugins/hostname/HostnameWidget.qml;
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

  # GTK icon theme for Thunar and other GTK apps
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
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
