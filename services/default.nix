{ config, inputs, ... }:

{
  imports = [
    #./forgejo.nix
    #./cockpit.nix broken
    ./cups.nix
    ./zoneminder.nix
    ./tailscale.nix
    ./jellyfin.nix
  ];
}
