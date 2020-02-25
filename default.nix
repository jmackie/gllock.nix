# Based on:
# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/slock.nix

{ shader ? "circle" }:
{ config, lib, pkgs, ... }: {

  options = {
    programs.gllock = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to install gllock screen locker with setuid wrapper.
        '';
      };
    };
  };

  config = lib.mkIf config.programs.gllock.enable {
    nixpkgs.config.packageOverrides = pkgs: {
      gllock = pkgs.callPackage ./gllock.nix { inherit shader; };
    };
    environment.systemPackages = [ pkgs.gllock ];

    # https://github.com/NixOS/nixpkgs/issues/9656#issuecomment-362873714
    security.wrappers.gllock.source = "${pkgs.gllock.out}/bin/gllock";
  };
}
