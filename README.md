# `gllock.nix`

Nix derivation and NixOS module for [`gllock`](https://github.com/kuravih/gllock).

## Testing

```
nix-build -E '(import <nixpkgs> {}).callPackage ./gllock.nix { shader = "circle"; }'
```
