{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.32.0/gogcli_0.32.0_darwin_arm64.tar.gz";
      hash = "sha256-csfJKMiLqRYmE+bBVZMJjynhGVpQ8n3YeUn7N3zyRaU=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.32.0/gogcli_0.32.0_linux_amd64.tar.gz";
      hash = "sha256-NCswhKhe61IeWNLhkE9dSr/O7BUFzqe1ZVf1d/ZRDqQ=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.32.0/gogcli_0.32.0_linux_arm64.tar.gz";
      hash = "sha256-0e7+2lVHufHdbIBNRXPihzz9YqOPktJQV+GPCvjOfpM=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.32.0";

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
