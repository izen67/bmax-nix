{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-ffmpeg
    exfatprogs
  ];

  # Jellyfin service setup
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "jellyfin";
    group = "plexshare";
    dataDir   = "/var/lib/jellyfin";
    configDir = "/var/lib/jellyfin/config";
    cacheDir  = "/var/cache/jellyfin";
    logDir    = "/var/log/jellyfin";
  };
}
