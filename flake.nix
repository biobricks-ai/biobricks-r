{
  description = "biobricks-R";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; };
      let
        biobricks-R-deps = with rPackages; [ arrow dplyr fs purrr reticulate ];
        # https://rgoswami.me/posts/nix-r-devtools/
        biobricks-R = rPackages.buildRPackage {
          name = "biobricks-R";
          src = ./.;
          propagatedBuildInputs = biobricks-R-deps;
        };
        rEnv = rWrapper.override {
          packages = with rPackages;
            biobricks-R-deps ++ [ biobricks-R pacman tidyverse withr ];
        };
      in {
        packages = { inherit biobricks-R rEnv; };
      });
}
