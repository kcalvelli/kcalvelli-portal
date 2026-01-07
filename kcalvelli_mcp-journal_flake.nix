{
  description = "MCP server for read-only journalctl access";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        mcp-journal = pkgs.python3Packages.buildPythonApplication {
          pname = "mcp-journal";
          version = "1.0.0";
          
          src = ./.;
          
          format = "other";
          
          nativeBuildInputs = [ pkgs.makeWrapper ];
          
          buildPhase = ''
            # No build needed for pure Python
          '';
          
          installPhase = ''
            mkdir -p $out/bin $out/lib/mcp-journal
            cp src/mcp_journal.py $out/lib/mcp-journal/
            
            makeWrapper ${pkgs.python3}/bin/python3 $out/bin/mcp-journal \
              --add-flags "$out/lib/mcp-journal/mcp_journal.py" \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.systemd ]}
          '';
          
          doCheck = true;
          
          checkPhase = ''
            export HOME=$(mktemp -d)
            ${pkgs.python3}/bin/python3 -m unittest discover -s TESTS/unit -p 'test_*.py' -v
          '';
          
          meta = with pkgs.lib; {
            description = "MCP server for read-only journalctl access";
            homepage = "https://github.com/kcalvelli/mcp-journal";
            license = licenses.mit;
            maintainers = [ ];
            platforms = platforms.linux;
          };
        };
        
      in {
        packages = {
          default = mcp-journal;
          mcp-journal = mcp-journal;
        };
        
        apps = {
          default = {
            type = "app";
            program = "${mcp-journal}/bin/mcp-journal";
          };
        };
        
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.python3
            pkgs.systemd
            pkgs.python3Packages.python-lsp-server
          ];
          
          shellHook = ''
            echo "MCP Journal Server Development Environment"
            echo "Python: $(python3 --version)"
            echo "systemd: $(systemctl --version | head -1)"
            echo ""
            echo "Commands:"
            echo "  python3 src/mcp_journal.py --help"
            echo "  python3 TESTS/acceptance_harness.py"
            echo "  python3 -m unittest discover -s TESTS/unit -v"
          '';
        };
        
        checks = {
          unit-tests = pkgs.runCommand "unit-tests" {
            buildInputs = [ pkgs.python3 ];
          } ''
            export HOME=$(mktemp -d)
            cd ${self}
            ${pkgs.python3}/bin/python3 -m unittest discover -s TESTS/unit -p 'test_*.py' -v
            touch $out
          '';
          
          acceptance-tests = pkgs.runCommand "acceptance-tests" {
            buildInputs = [ pkgs.python3 pkgs.systemd mcp-journal ];
          } ''
            export HOME=$(mktemp -d)
            cd ${self}
            ${pkgs.python3}/bin/python3 TESTS/acceptance_harness.py
            touch $out
          '';
        };
      }
    );
}
