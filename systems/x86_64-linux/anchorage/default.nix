{ inputs, pkgs, system, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix
    ./user-configuration.nix
  ];

  # ensure the system can boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ensure the system can be accessed remotely via ssh
  services.openssh.enable = true;

  # configure the ssh host keys (for impermanence)
  services.openssh.hostKeys = [
    {
      bits = 4096;
      path = "/persist/etc/ssh/ssh_host_rsa_key";
      type = "rsa";
    }
    {
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];

  # ensure the system can connect to the internet
  networking.hostName = "anchorage";
  networking.networkmanager.enable = true;
  
  # assign a unique machine id (for impermanence)
  environment.etc."machine-id".text = "fe9c6a3393894b9b85db659c7d41b51a";

  # configure the keyboard layout; ex: us
  services.xserver.xkb.layout = "us";
  console.keyMap = "us";

  # set the locale and timezone
  i18n.defaultLocale = "en_US.UTF-8"; # ex: en_US.UTF-8
  time.timeZone = "America/New_York"; # ex: America/New_York

  # configure standard fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
    ];
  };

  # enable printer support
  services.printing.enable = true;

  # disable sudo password prompts
  security.sudo.wheelNeedsPassword = false;

  # enable audio via pipewire
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # add additional packages to install
  environment.systemPackages = with pkgs; [
    # minimum packages to allow us to provision more nix systems
    gh git openssh openssl rsync helix nil nixos-anywhere
    inputs.agenix.packages.${system}.default
    # additional useful packages
    nix-index comma direnv devbox
  ];

  # configure our persistence module to persist core files and directories
  alaska.features.persistence.enable = true;
  alaska.features.persistence.persist.core = {
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [];

    users.directories = [
      "Desktop"
      "Documents"
      "Downloads"
      "Music"
      "Pictures"
      "Projects"
      "Public"
      "Templates"
      "Videos"
      { directory = ".ssh"; mode = "0700"; }
      ".config/nixos"
      ".config/gh"
    ];

    users.files = [
      ".bash_history"
      ".config/monitors.xml"
    ];
  };

  # enable the GNOME desktop environment
  alaska.desktops.gnome.enable = true;

  # enable the Just command runner
  alaska.features.just.enable = true;

  # enables Flatpak
  alaska.features.flatpak.enable = true;

  # enables Firefox
  alaska.apps.firefox.enable = true;

  # enables asusd
  alaska.features.asusd.enable = true;

  # enables Steam
  alaska.apps.steam.enable = true;

  # enables GPU-passthrough virtualization via KVM, QEMU, Looking Glass
  alaska.features.virtualization = {
    enable = true;
    user = "jacob";
    vfioIds = [ "1002:1681" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
