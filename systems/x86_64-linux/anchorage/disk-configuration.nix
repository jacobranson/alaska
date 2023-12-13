{ inputs, ... }:

{
  imports = [ inputs.disko.nixosModules.disko ];

  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/swap".neededForBoot = true;
  fileSystems."/etc/ssh".neededForBoot = true;
  
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "defaults" "size=2G" "mode=755" ];
    };
    disk."nvme0n1" = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              subvolumes = {
                "/nix" = {
                   mountpoint = "/nix";
                   mountOptions = [ "compress=zstd" "noatime" ];
                 };
                 "/persist" = {
                   mountpoint = "/persist";
                   mountOptions = [ "compress=zstd" "noatime" ];
                 };
                 "/swap" = {
                   mountpoint = "/swap";
                   mountOptions = [ "compress=zstd" "noatime" ];
                   swap.swapfile.size = "8G";
                 };
                 "/etc_ssh" = {
                   mountpoint = "/etc/ssh";
                   mountOptions = [ "compress=zstd" "noatime" ];
                 };
              };
            };
          };
        };
      };
    };
  };
}
