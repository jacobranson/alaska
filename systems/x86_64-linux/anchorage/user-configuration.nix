{ inputs, config, ... }:

let
  users = {
    root.hashedPasswordFile = config.age.secrets.password.path;
    "jacob" = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.password.path;
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGjzIlLawfSp6zmmZZoPtKZoGbsPhxS7BPWsMWRtUblQ code@jacobranson.dev"
      ];
    };
  };
in {
  imports = [ inputs.agenix.nixosModules.default ];

  users.users = users;
  alaska.features.persistence.users = users;

  age.secrets = {
    password.file = ../../../secrets/password.age;
  };
}
