# Configuration for example mac-mini

{ pkgs, ... }:
{
  networking.hostName = "mac-mini";
  networking.computerName = "Mac Mini";

  environment.systemPackages = with pkgs; [ google-chrome ];

  system.stateVersion = 5;
}
