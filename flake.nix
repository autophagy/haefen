{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    preludeSrc = {
      url = "github:dhall-lang/dhall-lang/v20.0.0";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, preludeSrc }:
    utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.haefen = pkgs.stdenv.mkDerivation {
          pname = "haefen";
          version = "0.1.0";
          src = ./.;

          buildInputs = [ pkgs.dhall ];

          buildPhase = ''
            export DHALL_PRELUDE=${preludeSrc}/Prelude/package.dhall
            export DRV=${placeholder "out"}
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
        };

        packages.default = self.packages.${system}.haefen;
      }
    );
}
