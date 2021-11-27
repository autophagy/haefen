{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/f096b7122ab08e93c8b052c92461ca71b80c0cc8.tar.gz") {}
}:
let
  gitignoreSrc = pkgs.fetchFromGitHub {
    owner = "hercules-ci";
    repo = "gitignore.nix";
    rev = "5b9e0ff9d3b551234b4f3eb3983744fa354b17f1";
    sha256 = "sha256:01l4phiqgw9xgaxr6jr456qmww6kzghqrnbc7aiiww3h6db5vw53";
  };

  preludeSrc = pkgs.fetchFromGitHub {
    owner = "dhall-lang";
    repo = "dhall-lang";
    rev = "v20.0.0";
    sha256 = "sha256-inKajh4BoqnwlHp5c3w2tKlc0H5Dg3s7EZKFOPsps+o=";
  };

  inherit (import gitignoreSrc { inherit (pkgs) lib; }) gitignoreSource;
in pkgs.stdenv.mkDerivation {
  pname = "haefen";
  version = "0.1.0";
  src = gitignoreSource ./.;

  buildInputs = [ pkgs.dhall ];

  buildPhase = ''
   export DHALL_PRELUDE=${preludeSrc}/Prelude/package.dhall
   echo $DHALL_PRELUDE
   buildDir=$(pwd)
   dhall text --file $src/index.dhall --output $buildDir/index.html
  '';

  installPhase = ''
    mkdir -p $out
    cp -rf main.css $out
    cp -rf index.gif $out
    cp -rf favicon.ico $out
    cp -rf index.html $out
  '';
}

