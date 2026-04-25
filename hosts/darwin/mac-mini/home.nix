# Home-manager configuration specific to example mac-mini

{ ... }:
{
  # macOS-specific settings
  targets.darwin = {
    defaults = {
      NSGlobalDomain = {
        # Disable natural scrolling (uses traditional scroll direction)
        "com.apple.swipescrolldirection" = false;
      };
    };
  };

  home.stateVersion = "25.11";
}
