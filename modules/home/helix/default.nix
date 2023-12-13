{ config, lib, pkgs,  ... }:

with lib;
with lib.alaska;

let
  cfg = config.alaska.programs.helix;
in {
  options.alaska.programs.helix = with types; {
    enable = mkBoolOpt' false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ nil ];

    programs.helix = {
      enable = true;

      settings = {
        theme = "adwaita-dark";

        editor = {
          line-number = "relative";
          bufferline = "multiple";
          cursor-shape.insert = "bar";
        };

        keys.normal = {
          "esc" = [ "collapse_selection" "keep_primary_selection" ];
          "C-c" = ":qa!";
        };
      };
    };
  };
}
