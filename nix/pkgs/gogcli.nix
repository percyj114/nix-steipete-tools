{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.31.1/gogcli_0.31.1_darwin_arm64.tar.gz";
      hash = "sha256-ozB0L/kqdAdGEJywMzjS/tR3obP02EFr1lFXj3HDHck=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.31.1/gogcli_0.31.1_linux_amd64.tar.gz";
      hash = "sha256-X1w164xWA6We4erzGQlGP06MX2RRMNmkKWVxlmp3rvI=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.31.1/gogcli_0.31.1_linux_arm64.tar.gz";
      hash = "sha256-cFxDxIvDkpfwAUNEpHIUUy3ZmGmOWkhVJHOIzfv5SYs=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.31.1";

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
