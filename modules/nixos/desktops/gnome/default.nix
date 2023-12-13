{ config, lib, pkgs, ... }:

with lib;
with lib.alaska;

let
  cfg = config.alaska.desktops.gnome;
in {
  options.alaska.desktops.gnome = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.libinput.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.excludePackages = [ pkgs.xterm ];

    environment.gnome.excludePackages = with pkgs; with pkgs.gnome; with pkgs.gnomeExtensions; [
      # replaced apps
      gnome-music             # replaced by amberol
      totem                   # replaced by clapper
      epiphany                # replaced by firefox
      gnome-system-monitor    # replaced by mission-center

      # extraneous apps
      gnome-tour              # GNOME Welcome app
      yelp                    # GNOME Help app
      seahorse                # GNOME Passwords app
      gnome-shell-extensions  # default gnome extensions set
      gnome-contacts
      gnome-weather
      gnome-clocks
      gnome-maps
    ];

    environment.systemPackages = with pkgs; with pkgs.gnome; with pkgs.gnomeExtensions; [
      # replacement apps
      amberol                  # replaces gnome-music
      clapper                  # replaces totem
      gnome-extension-manager  # replaces gnome-shell-extensions
      mission-center           # replaces gnome-system-monitor

      # extra apps
      appindicator             # for system tray support
      kooha                    # for screen recording
    ];

    xdg.portal.enable = true;
    xdg.portal.xdgOpenUsePortal = true;

    programs.dconf = (import ./dconf.nix { inherit lib; } );
  };
}
