{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/steipete/sag/releases/download/v0.4.0/sag_0.4.0_darwin_universal.tar.gz";
      hash = "sha256-1LIBMSzios8rQryYxHZWuK2wm/Bb4QhvBwPFyjGBgK8=";
    };
    "x86_64-linux" = {
      url = "https://github.com/steipete/sag/releases/download/v0.4.0/sag_0.4.0_linux_amd64.tar.gz";
      hash = "sha256-tujestJUtMxKkAjcRUTGk3hL90kstjQ5oDZ06vSDBVw=";
    };
  };
in
stdenv.mkDerivation {
  pname = "sag";
  version = "0.4.0";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp sag "$out/bin/sag"
    chmod 0755 "$out/bin/sag"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Command-line ElevenLabs TTS with mac-style flags";
    homepage = "https://github.com/steipete/sag";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "sag";
  };
}
