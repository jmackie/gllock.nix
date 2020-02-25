# `gllock.nix`

Nix derivation and NixOS module for [`gllock`](https://github.com/kuravih/gllock).

## Usage

Add the following to your `configuration.nix` 

```
{ ... }: {
  imports = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/jmackie/gllock.nix/archive/8965b8f904f77f7cfc9e0666284abd729faff752.tar.gz";
      sha256 = "1hcz4a6qb7k5gd2h09i5ac32z7mfnjjm76kv7xf1bahvh19h8mxb";
    }) { shader = "circle"; })
  ];
}
```

(you'll probably want to update the `rev` and `sha256`)

## Testing

```
nix-build -E '(import <nixpkgs> {}).callPackage ./gllock.nix { shader = "circle"; }'
```
