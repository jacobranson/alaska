{ lib, inputs, config, ... }:

with lib;
with lib.alaska;

let
  cfg = config.alaska.features.persistence;
in {
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.alaska.features.persistence = with types; {
    enable  = mkBoolOpt'      false;
    users   = mkOpt' anything null;
    persist = mkOpt' anything {};
  };
  
  config = mkIf cfg.enable (
    let flattened = flattenAttrset cfg.persist; in {
      environment.persistence."/persist" = {
        hideMounts = true;
      } // (with flattened; {
        inherit directories;
        inherit files;
        users = forEachNormalUser cfg.users (
          with flattened.users; {
            inherit directories;
            inherit files;
          });
      });
    }
  );
}
