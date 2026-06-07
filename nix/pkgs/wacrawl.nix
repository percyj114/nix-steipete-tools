{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/wacrawl/releases/download/v0.2.6/wacrawl_0.2.6_darwin_arm64.tar.gz";
      hash = "sha256-HIEL5dL+FZc2XFh51V2uSjcVDFTo67PHMyZ4kYckJDg=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/wacrawl/releases/download/v0.2.6/wacrawl_0.2.6_linux_amd64.tar.gz";
      hash = "sha256-jAGtSDsCptZBDH3BDJzQ4oszt7yOD9GJCCPkg5uVwcc=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/wacrawl/releases/download/v0.2.6/wacrawl_0.2.6_linux_arm64.tar.gz";
      hash = "sha256-P03nQLQD6+JFFP98WCzdwy8B/f4s9strotN8XrffIlk=";
    };
  };
in
stdenv.mkDerivation {
  pname = "wacrawl";
  version = "0.2.6";

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
