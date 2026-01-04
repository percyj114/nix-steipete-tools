{
  description = "clawdbot plugin: sag";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    root.url = "path:../..";
  };

  outputs = { self, nixpkgs, root }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
      sag = root.packages.${system}.sag;
    in {
      packages.${system}.sag = sag;

      clawdbotPlugin = {
        name = "sag";
        skills = [ ./skills/sag ];
        packages = [ sag ];
        needs = {
          stateDirs = [];
          requiredEnv = [];
        };
      };
    };
}
