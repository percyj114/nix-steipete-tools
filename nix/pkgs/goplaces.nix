{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.14/goplaces_0.4.14_darwin_arm64.tar.gz";
      hash = "sha256-cyZpbdwjv3lW7xoojf2M/P2TtVlBFzTWRS7m9AKRUE0=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.14/goplaces_0.4.14_darwin_amd64.tar.gz";
      hash = "sha256-OY7pYv0ef4Nd5jWumbJjB95v121LPzjY1f8ltqAArXc=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.14/goplaces_0.4.14_linux_amd64.tar.gz";
      hash = "sha256-40Iw2W6YiPjPv0PQ2BZBX2y4L0PDYifRK67H2ZJ5a38=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.14/goplaces_0.4.14_linux_arm64.tar.gz";
      hash = "sha256-o3fp32dJUXfhNYCQ8K0nebBgQHHRZi9pQ/1SS1WgiZU=";
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
  version = "0.4.14";

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
