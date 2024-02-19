{
  description = "The universal transpiler collection";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    flake-utils,
    nixpkgs,
    zig-overlay,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          zig-overlay.overlays.default
          # WebUI fails to build on Linux with unexported symbol
          # - emcc: error: undefined exported symbol: "__ZNSt3__212basic_stringIcNS_11char_traitsIcEENS_9allocatorIcEEE9__grow_byEmmmmmm" [-Wundefined] [-Werror]
          # (final: prev: {
          #   tree-sitter = prev.tree-sitter.override {webUISupport = true;};
          # })
        ];
      };
    in {
      # packages exported by the flake
      packages = {};

      # nix run
      apps = {};

      # nix fmt
      formatter = pkgs.alejandra;

      # nix develop -c $SHELL
      devShells.default = pkgs.mkShell {
        name = "default dev shell";

        buildInputs = [
          pkgs.pkg-config
          pkgs.zigpkgs.master
        ];

        packages =
          [
            pkgs.graphviz
            pkgs.tracy
            pkgs.tree-sitter
          ]
          ++ pkgs.lib.optionals (pkgs.stdenv.isLinux) [
            pkgs.strace
            pkgs.valgrind
          ];
      };
    });
  in
    outputs;
}
