{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.9.1/discrawl_0.9.1_darwin_arm64.tar.gz";
      hash = "sha256-tmp0iSEXq4jyxpozod/XHHMUdf6I55xzalGkzDuYbuw=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.9.1/discrawl_0.9.1_linux_amd64.tar.gz";
      hash = "sha256-knz8uQd3QFlw8qtPXYiBv/+MdV/DSUL5ss5OujMfcfs=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.9.1/discrawl_0.9.1_linux_arm64.tar.gz";
      hash = "sha256-+a4ciX56dq47PvU3vrNsqViGWQIV0aTDbIyuku5Qmp4=";
    };
  };
in
stdenv.mkDerivation {
  pname = "discrawl";
  version = "0.9.1";

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
