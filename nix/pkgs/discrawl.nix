{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.10.0/discrawl_0.10.0_darwin_arm64.tar.gz";
      hash = "sha256-ZCA8Ph0Buck2kmPkGnebaZ+LRZePGESFmfihgATuJSc=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.10.0/discrawl_0.10.0_linux_amd64.tar.gz";
      hash = "sha256-FKHgsA80Laxzl+4fgleXk5DhChA/+PFiYSy56nAE25w=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.10.0/discrawl_0.10.0_linux_arm64.tar.gz";
      hash = "sha256-iXb2iKmkg+VlttpIbjcBVDESL6gmGGKSygeWU1hsfjc=";
    };
  };
in
stdenv.mkDerivation {
  pname = "discrawl";
  version = "0.10.0";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/doc/discrawl"
    cp $(find . -type f -name discrawl | head -1) "$out/bin/discrawl"
    chmod 0755 "$out/bin/discrawl"
    if [ -f LICENSE ]; then
      cp LICENSE "$out/share/doc/discrawl/"
    fi
    if [ -f README.md ]; then
      cp README.md "$out/share/doc/discrawl/"
    fi
    runHook postInstall
  '';

  meta = with lib; {
    description = "Mirror Discord into SQLite and search server history locally";
    homepage = "https://github.com/openclaw/discrawl";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "discrawl";
  };
}
