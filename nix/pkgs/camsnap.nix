{ lib, stdenv, fetchurl, ffmpeg, makeWrapper }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/steipete/camsnap/releases/download/v0.6.1/camsnap_0.6.1_darwin_arm64.tar.gz";
      hash = "sha256-Jzv/PV7wdJ5odCMHxYck3F4Qm4DByXzdQI45qqPXfb0=";
    };
    "x86_64-linux" = {
      url = "https://github.com/steipete/camsnap/releases/download/v0.6.1/camsnap_0.6.1_linux_amd64.tar.gz";
      hash = "sha256-V7m4XsRXUCHkAflP6cVNZpt/3S+SuKdEzr6fUweXenw=";
    };
    "aarch64-linux" = {
      url = "https://github.com/steipete/camsnap/releases/download/v0.6.1/camsnap_0.6.1_linux_arm64.tar.gz";
      hash = "sha256-w5d41AvLSmAUGhlz4CYKJAiOCL6omwlYnvDuVhj5UIU=";
    };
  };
in
stdenv.mkDerivation {
  pname = "camsnap";
  version = "0.6.1";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  nativeBuildInputs = [ makeWrapper ];
  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/doc/camsnap"
    cp $(find . -type f -name camsnap | head -1) "$out/bin/camsnap"
    chmod 0755 "$out/bin/camsnap"
    wrapProgram "$out/bin/camsnap" --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}"
    if [ -f LICENSE ]; then
      cp LICENSE "$out/share/doc/camsnap/"
    fi
    if [ -f README.md ]; then
      cp README.md "$out/share/doc/camsnap/"
    fi
    runHook postInstall
  '';

  meta = with lib; {
    description = "One command to grab frames, clips, or motion alerts from RTSP/ONVIF cams";
    homepage = "https://github.com/steipete/camsnap";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "camsnap";
  };
}
