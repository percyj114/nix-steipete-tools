{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.13/goplaces_0.4.13_darwin_arm64.tar.gz";
      hash = "sha256-fyrE7kki1YQz6xH1QuRx4ntKzPBwgzinX8Q95kbkEp4=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.13/goplaces_0.4.13_darwin_amd64.tar.gz";
      hash = "sha256-FR0LRqovqepDh/0/QmhLiD7YgPcx8w2f+fQFYG81hR0=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.13/goplaces_0.4.13_linux_amd64.tar.gz";
      hash = "sha256-fEvOhnl8E+1voemgpNvWjjHdl77tN+b6ihQgKHNs5JQ=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/goplaces/releases/download/v0.4.13/goplaces_0.4.13_linux_arm64.tar.gz";
      hash = "sha256-42swnIzXQ+AUY65PbYj4YiMZsy3FXjgXEz7cnqfiUvs=";
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
  version = "0.4.13";

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
