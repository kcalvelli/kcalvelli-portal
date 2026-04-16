{
  description = "kcalvelli-portal — engineering portfolio (Zola + Structurizr)";

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
            zola

            # Diagrams: Structurizr DSL → C4-PlantUML → SVG
            structurizr-cli
            plantuml-c4

            # Tooling
            gh
            jq
          ];

          shellHook = ''
            echo "kcalvelli-portal devshell"
            echo "  zola serve                → live preview"
            echo "  zola build                → static site → public/"
            echo "  ./scripts/render-diagrams.sh → re-render SVGs from diagrams/cairn.dsl"
          '';
        };
      });
}
