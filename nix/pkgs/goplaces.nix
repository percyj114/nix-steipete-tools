{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.3/goplaces_0.4.3_darwin_arm64.tar.gz";
      hash = "sha256-a0d9H63jqkZwMdU35D+apmcE4QAYDynRkMv2lf4egDk=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.3/goplaces_0.4.3_darwin_amd64.tar.gz";
      hash = "sha256-pqP+44WgSR+tHQW5zmq2MTIuigWPKolhRl3CCXtwIoc=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.3/goplaces_0.4.3_linux_amd64.tar.gz";
      hash = "sha256-2dBR/D7hxX0IU6kHlfZ/8ZurJHTOtacWe+0aVsdlI5Y=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.3/goplaces_0.4.3_linux_arm64.tar.gz";
      hash = "sha256-jYy2Vmxz3IP/4Pw1TgQy5O5nN8qinHJHxqqhITl4GfI=";
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
  version = "0.4.3";

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
