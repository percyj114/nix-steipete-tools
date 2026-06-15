{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.27.1/gogcli_0.27.1_darwin_arm64.tar.gz";
      hash = "sha256-oNXHN8YYC6PGCmwXyl7hHGcFFh1IhKxXnUxG97dxjjQ=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.27.1/gogcli_0.27.1_linux_amd64.tar.gz";
      hash = "sha256-ruK0d0KOgWM6GvdyJuo7MasNeKcTegV7sTHNEpe1iPU=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.27.1/gogcli_0.27.1_linux_arm64.tar.gz";
      hash = "sha256-YsWavMe9U8SsbQIZtCWNd7M9T1shWiS5ZuVBtXGLqPI=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.27.1";

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
