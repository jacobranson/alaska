let
  targetSystem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGgxdR5GJKKijvVgFrjeJmnj3HDGoKKHRJ3YU1EUHdWu root@nixos";
  sourceSystem = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGjzIlLawfSp6zmmZZoPtKZoGbsPhxS7BPWsMWRtUblQ code@jacobranson.dev";
in {
  "password.age".publicKeys = [ targetSystem sourceSystem ];
}
