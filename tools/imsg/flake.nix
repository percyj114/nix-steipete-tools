{
  description = "clawdbot plugin: imsg";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    root.url = "path:../..";
  };

  outputs = { self, nixpkgs, root }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
      imsg = root.packages.${system}.imsg;
    in {
      packages.${system}.imsg = imsg;

      clawdbotPlugin = {
        name = "imsg";
        skills = [ ./skills/imsg ];
        packages = [ imsg ];
        needs = {
          stateDirs = [];
          requiredEnv = [];
        };
      };
    };
}
