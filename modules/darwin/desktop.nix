# Desktop-oriented packages and visual defaults for darwin hosts.

{ ... }:
{
  homebrew = {
    enable = true;
    onActivation.upgrade = true;
    greedyCasks = true;
    brews = [
      "lua-language-server"
      "tree-sitter"
    ];
    casks = [
      "ghostty"
      "jellyfin-media-player"
      "mullvad-vpn"
    ];
  };
}
