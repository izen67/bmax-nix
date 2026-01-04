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

  # Create plexshare group
  users.groups.plexshare = { };

  # Samba login user
  users.users.sambaplex = {
    isNormalUser = true;
    extraGroups = [ "plexshare" ];
  };

  # Admin access
  users.users.globaladmin.extraGroups = [ "plexshare" ];

  # Correct exFAT mount MUST set uid/gid or perms won't work
  fileSystems."/media/plex" = {
    device = "UUID=2A95-B9FC";
    fsType = "exfat";
    options = [
      "uid=0"                # owner = root
      "gid=plexshare"        # group owns the share
      "fmask=0007"           # files = 770
      "dmask=0007"           # dirs = 770
      "noatime"
      "nofail"
    ];
  };

  # tmpfiles is meaningless for exFAT, but creating directory is fine
  systemd.tmpfiles.rules = [
    "d /media/plex 2770 root plexshare -"
  ];

  # Samba share
  services.samba = {
    enable = true;
    securityType = "user";
    shares = {
      plex = {
        comment = "Plex SSD";
        path = "/media/plex";
        browseable = true;
        "read only" = false;
        "guest ok" = false;
        "create mask" = "0770";
        "directory mask" = "0770";
        "valid users" = [ "@plexshare" ];
      };
    };
  };
}
