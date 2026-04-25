# Darwin/macOS-specific home-manager configuration

{
  config,
  lib,
  ...
}:
let
  # Helper function to create a dock app entry
  mkDockApp = path: {
    tile-data = {
      file-data = {
        _CFURLString = path;
        _CFURLStringType = 0;
      };
    };
  };
in
{
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    PODMAN_COMPOSE_PROVIDER = "podman-compose";
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  # Darwin-specific zsh configuration
  programs.zsh = {
    initContent = ''
      export LIBRARY_PATH="$(/usr/bin/xcrun --show-sdk-path)/usr/lib"
    '';
    shellAliases = {
      norb = "sudo HOME=$HOME darwin-rebuild switch --flake /etc/nixos#$HOSTNAME --impure";
    };
  };

  # macOS Dock configuration
  targets.darwin = {
    defaults = {
      "com.apple.dock" = {
        # Dock apps configuration
        persistent-apps = [
          (mkDockApp "/System/Applications/Launchpad.app")
          (mkDockApp "/Applications/Nix Apps/Google Chrome.app")
          (mkDockApp "/Applications/Nix Apps/Brave Browser.app")
          (mkDockApp "/Applications/Nix Apps/Moonlight.app")
          (mkDockApp "/Applications/Jellyfin Media Player.app")
          (mkDockApp "/Applications/Ghostty.app")
          (mkDockApp "/Applications/Nix Apps/Obsidian.app")
        ];
        # Optional dock settings
        autohide = false;
        show-recents = false;
        tilesize = 48;
      };
    };
  };

  # Set desktop wallpaper (user-specific)
  # Note: Home Manager doesn't have native wallpaper support on macOS,
  # so we use home.activation to run osascript
  home.activation.setWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD /usr/bin/osascript -e 'tell application "Finder" to set desktop picture to POSIX file "${config.home.homeDirectory}/Repos/nix-config/media/wallpapers/rose-pine-moon-wallpaper.jpeg"'
  '';
}
