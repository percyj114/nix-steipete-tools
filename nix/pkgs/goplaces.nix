{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.12/goplaces_0.4.12_darwin_arm64.tar.gz";
      hash = "sha256-27oy6mnNmq0mgdS+5NJA8SV6tgHIxyNfwG2wArDh4uQ=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.12/goplaces_0.4.12_darwin_amd64.tar.gz";
      hash = "sha256-KQV7MFTe8bwf64kTMFNK4nICY4IOCSisBvLRoYC2XuM=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.12/goplaces_0.4.12_linux_amd64.tar.gz";
      hash = "sha256-6X3CJh0BHcFVhtRoSADqmYBXhgc2aG6N/CeJZHkQzA4=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.12/goplaces_0.4.12_linux_arm64.tar.gz";
      hash = "sha256-BTwRtQv8DOAKagerMX8HegYx0GyjT2dGJZ6VOng5g+8=";
    };
  };

  meta = with lib; {
    description = "Modern Go client + CLI for the Google Places API (New)";
    homepage = "https://github.com/openclaw/goplaces";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "goplaces";
  };

in
stdenv.mkDerivation {
  pname = "goplaces";
  version = "0.4.12";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/doc/goplaces"
    cp $(find . -type f -name goplaces | head -1) "$out/bin/goplaces"
    chmod 0755 "$out/bin/goplaces"
    if [ -f LICENSE ]; then
      cp LICENSE "$out/share/doc/goplaces/"
    fi
    if [ -f README.md ]; then
      cp README.md "$out/share/doc/goplaces/"
    fi
    runHook postInstall
  '';

  inherit meta;
}
