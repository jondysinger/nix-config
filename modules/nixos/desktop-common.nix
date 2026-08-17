# Desktop-oriented packages, fonts, and graphical services for NixOS hosts.

{
  lib,
  pkgs,
  pkgs-unstable,
  mediaDir,
  ...
}:
let
  obsidian-appimage = pkgs.appimageTools.wrapType2 {
    pname = "obsidian";
    version = "1.12.7";

    src = pkgs.fetchurl {
      url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.12.7/Obsidian-1.12.7.AppImage";
      hash = "sha256-9ti5b+aFqGMsgZzAk6JIrOD2urQQ9EpskpomEbHrsXw=";
    };
  };

  obsidian-desktop = pkgs.makeDesktopItem {
    name = "obsidian";
    desktopName = "Obsidian";
    genericName = "Markdown Editor";
    comment = "Knowledge base and note-taking app";
    exec = "obsidian %u";
    icon = "obsidian";
    categories = [
      "Office"
      "TextEditor"
    ];
    mimeTypes = [
      "text/markdown"
      "x-scheme-handler/obsidian"
    ];
  };
in
{
  # Theme related
  stylix.targets.chromium.enable = false; # Better results to use GTK theme instead
  stylix.targets.qt = {
    # 'gnome' is deprecated/unsupported and can break some Qt5 apps (e.g. MakeMKV)
    # via qgnomeplatform + GSettings/dconf. Use a supported Qt platform theme.
    # Stylix currently supports `qtct`.
    platform = lib.mkForce "qtct";
  };
  stylix.image = mediaDir + "/wallpapers/rose-pine-moon-wallpaper.jpeg";

  # Keep xserver for XWayland compatibility
  services.xserver.enable = true;
  programs.dconf.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.systemPackages = [
    obsidian-appimage
    obsidian-desktop
  ]
  ++ (with pkgs; [
    brave

    ghostty # Terminal
    easyeffects # Audio effect
    piper # Mouse settings
    jellyfin-media-player
  ])
  ++ (with pkgs-unstable; [
    moonlight-qt
    mullvad-vpn
  ]);

  programs.steam.enable = true;

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    vista-fonts
    nerd-fonts.jetbrains-mono
    dejavu_fonts
    noto-fonts
  ];
}
