{
  pkgs,
  ...
}:
{
  networking.hostName = "desktop-pc";

  boot.kernelParams = [
    "amdgpu.gpu_recovery=1"
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      vulkan-loader
      vulkan-validation-layers
      vkd3d
      libva-vdpau-driver
      libva
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      driversi686Linux.mesa
      vulkan-loader
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
  };
  hardware.enableRedistributableFirmware = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  environment.systemPackages = with pkgs; [
    # Backup tools
    restic

    # AMD GPU tools
    libva-utils
    vulkan-tools
    radeontop
  ];

  # Sunshine for remote streaming from this host
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  system.stateVersion = "25.11";
}
