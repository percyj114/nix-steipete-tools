{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/steipete/discrawl/releases/download/v0.6.5/discrawl_0.6.5_darwin_arm64.tar.gz";
      hash = "sha256-nxt8Pq0ldbf4QefkBYDMIEzp9dRZUBuK7GBygI+4HDc=";
    };
    "x86_64-linux" = {
      url = "https://github.com/steipete/discrawl/releases/download/v0.6.5/discrawl_0.6.5_linux_amd64.tar.gz";
      hash = "sha256-0lLlZYWZgvebBNWfZjicdB+o9tJ43N4n3CxAQ9mLfHM=";
    };
    "aarch64-linux" = {
      url = "https://github.com/steipete/discrawl/releases/download/v0.6.5/discrawl_0.6.5_linux_arm64.tar.gz";
      hash = "sha256-k+ls+9dKvBLaMbThCoNgn6vQxGhviDeXaH6JmbeBrLM=";
    };
  };
in
stdenv.mkDerivation {
  pname = "discrawl";
  version = "0.6.5";

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
    homepage = "https://github.com/steipete/discrawl";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "discrawl";
  };
}
