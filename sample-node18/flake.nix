{
  description = "A very basic flake";
  nixConfig.bash-prompt = "\[nix-develop\]$ ";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem(system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.typescript
            pkgs.nodejs_18
          ];
        };
      }
    );
}
