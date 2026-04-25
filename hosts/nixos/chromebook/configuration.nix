{ pkgs, ... }:
{
  networking.hostName = "chromebook";

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  system.stateVersion = "25.11";
}
