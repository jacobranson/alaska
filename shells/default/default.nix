{ pkgs, inputs, system, ... }:

pkgs.mkShell {
  shellHook = ''
    export EDITOR=hx

    agenix() {
      command agenix \
        --identity extrafiles/etc/ssh/ssh_host_ed25519_key \
        --rules secrets/__secrets__.nix "$@"
    }
  '';

  packages = with pkgs; [
    gh git openssh openssl
    rsync helix nil nixos-anywhere
    inputs.agenix.packages.${system}.default
  ];
}
