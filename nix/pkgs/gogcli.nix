{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.46.0/gogcli_0.46.0_darwin_arm64.tar.gz";
      hash = "sha256-enEziHBmWg/3/09ddvnhzB9uAckeotQHge9dPrWHpCw=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.46.0/gogcli_0.46.0_linux_amd64.tar.gz";
      hash = "sha256-1Tz4nwwqIzghEhLjgLPvysrdTiflAMuOftLNgqc52i4=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.46.0/gogcli_0.46.0_linux_arm64.tar.gz";
      hash = "sha256-muadEXzviVqhxQtYWdfT3vRcVYCIayXcHH88/hKO0N0=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.46.0";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp gog "$out/bin/gog"
    chmod 0755 "$out/bin/gog"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Google CLI for Gmail, Calendar, Drive, and Contacts";
    homepage = "https://github.com/openclaw/gogcli";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "gog";
  };
}
