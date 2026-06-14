{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.26.0/gogcli_0.26.0_darwin_arm64.tar.gz";
      hash = "sha256-aMoKALcy4v93r0cWG1Mjf0kYwUgtC6XkNGyElNyFdmc=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.26.0/gogcli_0.26.0_linux_amd64.tar.gz";
      hash = "sha256-p2fhdsmqR19S5z5v3edPXKFo8FqfMlEXz6mToSr311M=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.26.0/gogcli_0.26.0_linux_arm64.tar.gz";
      hash = "sha256-nxDySa67Ly0hO7t/TNsJPyJEhMBSlJEejbqHDCghHyI=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.26.0";

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
