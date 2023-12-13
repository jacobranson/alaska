{ config, lib, ... }:

with lib;
with lib.alaska;

let
  cfg = config.alaska.apps.steam;
in {
  options.alaska.apps.steam = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    system.userActivationScripts.makeSteamSymlinks.text = ''
      ln -sfn ~/Steam/.local/share/Steam/ ~/.local/share/Steam
      ln -sfn ~/Steam/.steam ~/.steam
    '';

    alaska.features.persistence.persist.steam = {
      users.directories = [
        "Steam"
      ];
    };
  };
}
