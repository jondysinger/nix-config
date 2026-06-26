# Shared desktop-oriented packages and visual defaults for graphical hosts.

{
  pkgs,
  pkgs-unstable,
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
  environment.systemPackages =
    [
      obsidian-appimage
      obsidian-desktop
    ]
    ++ (with pkgs; [
      brave
    ])
    ++ (with pkgs-unstable; [
      moonlight-qt
    ]);

  # System wide theme integration
  stylix = {
    enable = true;
    base16Scheme = pkgs.base16-schemes + "/share/themes/rose-pine.yaml";
    polarity = "dark";
    fonts = {
      sizes = {
        applications = 10;
        desktop = 10;
        popups = 10;
        terminal = 10;
      };
      serif = {
        package = pkgs.vista-fonts;
        name = "Times New Roman";
      };
      sansSerif = {
        package = pkgs.vista-fonts;
        name = "Arial";
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
