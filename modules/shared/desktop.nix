# Shared desktop-oriented packages and visual defaults for graphical hosts.

{ pkgs, ... }:
{
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
