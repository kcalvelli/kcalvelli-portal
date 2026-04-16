{
  description = "kcalvelli-portal — engineering portfolio (MkDocs + Structurizr)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          name = "kcalvelli-portal";

          packages = with pkgs; [
            # Site
            mkdocs
            python3Packages.mkdocs-material
            python3Packages.pymdown-extensions

            # Diagrams: Structurizr DSL → C4-PlantUML → SVG
            structurizr-cli
            plantuml-c4

            # Tooling
            gh
            jq
          ];

          shellHook = ''
            echo "kcalvelli-portal devshell"
            echo "  mkdocs serve              → live preview"
            echo "  mkdocs build --strict     → build check"
            echo "  ./scripts/render-diagrams.sh → re-render SVGs from diagrams/cairn.dsl"
          '';
        };
      });
}
