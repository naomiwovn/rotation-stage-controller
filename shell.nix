{nixpkgs ? import <nixpkgs> {} }:
let
    inherit (nixpkgs) pkgs;
    inherit (pkgs) haskellPackages;

    # Add haskell packages here for custom ghc
    haskellDeps = ps: with ps; [
        base
        lens
        mtl
    ];
    # create custom ghc package in nix 
    ghc = haskellPackages.ghcWithPackages haskellDeps;

    # Add non-haskell packages here include new ghc 
    nixPackages = [
        ghc
        pkgs.gdb # <- 
        haskellPackages.cabal-install # <- 
    ];
in
# standard way of building nix derivation 
pkgs.stdenv.mkDerivation {
    name = "env";
    # which nix packages we depend on and require the custom ghc to have
    # gdb and cabal-install... see <- 
    buildInputs = nixPackages;
}

# use:
# nix-shell --pure shell.nix