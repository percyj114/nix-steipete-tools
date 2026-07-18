{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/wacrawl/releases/download/v0.3.4/wacrawl_0.3.4_darwin_arm64.tar.gz";
      hash = "sha256-ziEQfVdPxlGTe8QF4AooJOmqCeGb4wUEkK6FF1IbF8A=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/wacrawl/releases/download/v0.3.4/wacrawl_0.3.4_linux_amd64.tar.gz";
      hash = "sha256-/UNZd5cmuqvDR64b9VejQs113cWWgPBhE89FSvfmOCg=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/wacrawl/releases/download/v0.3.4/wacrawl_0.3.4_linux_arm64.tar.gz";
      hash = "sha256-9xNdk0S4LT4eJV47MWrbF+yUuNHgi1qiiAlQGqWE3DY=";
    };
  };
in
stdenv.mkDerivation {
  pname = "wacrawl";
  version = "0.3.4";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/doc/wacrawl"
    cp $(find . -type f -name wacrawl | head -1) "$out/bin/wacrawl"
    chmod 0755 "$out/bin/wacrawl"
    if [ -f LICENSE ]; then
      cp LICENSE "$out/share/doc/wacrawl/"
    fi
    if [ -f README.md ]; then
      cp README.md "$out/share/doc/wacrawl/"
    fi
    runHook postInstall
  '';

  meta = with lib; {
    description = "Read-only local archive and search for WhatsApp Desktop data";
    homepage = "https://github.com/steipete/wacrawl";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "wacrawl";
  };
}
