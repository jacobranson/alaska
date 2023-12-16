{ config, lib, ... }:

with lib;
with lib.alaska;

let
  cfg = config.alaska.features.asusd;
in {
  options.alaska.features.asusd = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    services.asusd = {
      enable = true;
      enableUserService = true;
    };

    services.supergfxd = {
      enable = true;
      settings = {
        "gfx_vfio_enable" = true;
      };
    };
  };
}
