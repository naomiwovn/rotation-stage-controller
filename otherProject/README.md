# learnyouahaskell

## Lists:
index with !!
```
listB = [1,2,3,4,5]
listB !! 2
> 3
```
Head:       return 1st element  
Tail:       returns everything but 1st element  
last:       returns last element (the real tail)  
init:       everything but the last element   
length:     
null:       
reverse:    
take:       
drop:       
maximum:    
minimum:    
sum:        
product:    
elem:       check if elem in list 4 \`elem\` [1,2,3,4]  



head    
0----- 

tail    
-00000 

last    
-----0 

init   
00000-




Some stray haskell code from https://maybevoid.com/posts/2019-01-27-getting-started-haskell-nix.html

Install cabal-install globally
```
nix-env -i cabal-install
```

we can try libraries with nix
```
nix-shell -p "haskellPackages.ghcWithPackages (pkgs: [pkgs.lens])"
```

ex: now if we open ghci inside of nix-shell we can use lens modules
```
ghci
import Control.Lens
("hello", "world")^._2
"world"
```

For complex nix setups, use shell.nix file
ex:
```
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

```
use:
```
nix-shell --pure shell.nix
```
The --pure flag makes sure you can only access the packages you have defined
this keeps you from accidentally using global packages that you installed in your system 


# START A FRESH PROJECT 

run cabal init inside the nix sandbox. This will create our .cabal file
```
nix-shell --pure -p ghc cabal-install --run "cabal init"
```

Now we can use the cabal2nix command to generate a default.nix file from the .cabal file. 
```
nix-shell --pure -p cabal2nix --run "cabal2nix ." > default.nix
```

The default.nix generated expects some arguments and cannot be called directly from nix-build. It contains a function that generates the Nix package given the expected arguments.

Give it the arguments with release.nix. This calls it with the standard arguments

release.nix
```
let
    pkgs = import <nixpkgs> { };
in
    pkgs.haskellPackages.callPackage ./default.nix { }
```

Now build haskell Executable with:
```
nix-build release.nix
```

The project will be compiled in a pure Nix environment and can find the executable in result/bin/ 

The package or derivation from release.nix can be imported by other Nix files! :O 

Or you can use nix-shell to enter a shell with the haskell dependencies in default.nix 
```
nix-shell --attr env release.nix
```
The --attr is a Haskell specific way of getting the shell environment from Haskell Nix packages. NOTE: the shell does not include cabal by default, which is why we install cabal-install globally with 
```
nix-env -i cabal-install
```