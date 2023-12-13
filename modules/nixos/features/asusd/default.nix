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
    services.supergfxd.enable = true;
    services.asusd.enable = true;
    services.asusd.enableUserService = true;
  };
}
