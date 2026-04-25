{
  pkgs,
  ...
}:
{
  networking.hostName = "nas";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  environment.systemPackages = with pkgs; [
    # Backup tools
    restic

    # RAID tools
    mdadm
    sg3_utils
    gptfdisk
    parted
  ];

  # Sunshine for remote streaming from this host
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # Jellyfin media server
  services.jellyfin.enable = true;
  services.jellyfin.openFirewall = true;

  # Allow Jellyfin to read/write the media tree and access GPU for hardware transcoding.
  users.users.jellyfin.extraGroups = [
    "media"
    "render"
  ];

  system.stateVersion = "25.11";
}
