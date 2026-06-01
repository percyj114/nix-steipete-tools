{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.21.0/gogcli_0.21.0_darwin_arm64.tar.gz";
      hash = "sha256-59/cIsM+lFSJCJAm8B80+36VT+OnQIHH7mdRxpr3KSk=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.21.0/gogcli_0.21.0_linux_amd64.tar.gz";
      hash = "sha256-YTHz7iOusU4LhoyO8tLy1rFY6DQVXm9GMeJ5HPOssic=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.21.0/gogcli_0.21.0_linux_arm64.tar.gz";
      hash = "sha256-GVa2zEefKNJbwelVyFau7USwXJUEaE0T2Rg3rCAnZw4=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.21.0";

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
