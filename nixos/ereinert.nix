{ pkgs, ... }:

{
  networking.hostName = "ereinert-work";

  nixpkgs.overlays = [ (import ../home-manager/overlays.nix) ];

  services.xserver.displayManager.autoLogin.user = "ereinert";

  users.users.ereinert = {
    extraGroups = [ "audio" "docker" "wheel" ];
    hashedPassword = "";
    home = "/home/ereinert";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCozwyCmg3mPDHPn5QgZiqqEA+eyd5qtZTlncvCuz4HzIpNW1MQBwwlh43+0aPG7shr3G2BTfmGaWQB8/xAvJtNzFa2U84giEW7PhtWGtH338favimdNNtnR3qe8ME3XyjAFoiycmKneyZGhcyoOPiuQpTlW8HTmo0hGae0bhfDKexAhActDsFQc5DsOQuIr2RsMxSTWFxQp87LoLrO7KTTdcpOYWX/ZT8JAhyAdqFcQzPvGil5CDOBTNoD67c8gay6H0aOfR6F17gm0izz0W1PUoG7VGN5QDMv/NhVVE08/kF13Kxyj+fR0o6Nku++5CvTuwDJUubrGwjjmEN3kBo+r/TV1qGsq928ev4O3I1wPigZAEeZBfkE7xYYBvTK9IxMoQDFGtIDyjABA/V+prtxJTj2ttR36W72dlK3ofWrV5Et/ABbGocvK3dR4SjLDrQs0jfKWksUGFmB06X/FkbV73RY/+5zJiWqi78qGTuoR1qM0px7QDwJWhqcfgxt2hv4NFjgW4cc7FsuDqexZXj0ipH8OVl1k2smX1VQnsHs1XPO+65XaHAKs/wvA6w9UMAqkrc3Mt2PZ2errspzqxlmBKw+pPbqIeUOyU7/mYX713mON66R7S+iROYOAy5uxmlue0bqkyMvxqmi4LaowwW6hnEnO4LPI7bCNCEPSRn6WQ== ereinert@hippo.com"
    ];
    shell = pkgs.zsh;
  };
}
