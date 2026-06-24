{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.31.0/gogcli_0.31.0_darwin_arm64.tar.gz";
      hash = "sha256-7oEajbK07r3KCDgwo4ZXgjHnR2FyDboWcVLIU4i1h+g=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.31.0/gogcli_0.31.0_linux_amd64.tar.gz";
      hash = "sha256-+Nb3DnMP9MpWgLCmZLOX5vDrsuh/KHOhzoGVC16zhIQ=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.31.0/gogcli_0.31.0_linux_arm64.tar.gz";
      hash = "sha256-F7NarLmWmkIwB7pEUngO7fIBcjRIWs/zRimhB7VWfAo=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.31.0";

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
