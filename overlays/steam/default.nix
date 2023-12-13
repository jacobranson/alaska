{ ... }:

final: prev: {
  steam = prev.steam.override {
    extraProfile = ''
      export STEAM_FORCE_DESKTOPUI_SCALING=2
    '';
    extraBwrapArgs = [
      "--chdir ~ --bind ~/Steam ~"
    ];
  };
}
