{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    openfoam-pkg.url = "github:oscilococcinum/openfoam-nix";
  };

  outputs = { nixpkgs, openfoam-pkg, ... }@inputs: {
    packages = builtins.listToAttrs (map (system: 
      {
        name = system;
        value = with import nixpkgs { inherit system; config.allowUnfree = true;}; rec {
          
          hisa = pkgs.callPackage (import ./hisa) { openfoam = openfoam-pkg.openfoam.${system}; };
          hisa-unstable = hisa.override { version = "unstable"; };
        };
      }
    )[ "x86_64-linux" "aarch64-linux" ]);
  };
}
