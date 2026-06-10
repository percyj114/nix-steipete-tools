{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/steipete/sonoscli/releases/download/v0.3.2/sonoscli_0.3.2_darwin_arm64.tar.gz";
      hash = "sha256-TguEPiJZS83e2b2cVXsQ1BH/D+plIiM3Lxs4CbwmfRQ=";
    };
    "x86_64-linux" = {
      url = "https://github.com/steipete/sonoscli/releases/download/v0.3.2/sonoscli_0.3.2_linux_amd64.tar.gz";
      hash = "sha256-zIluuT8sXXy7Zoi5P2uW12PCU+gB1qV19da0ruylA7M=";
    };
    "aarch64-linux" = {
      url = "https://github.com/steipete/sonoscli/releases/download/v0.3.2/sonoscli_0.3.2_linux_arm64.tar.gz";
      hash = "sha256-+XOEz3lc3lp/cn/tBhNvBR0lXrHgjuPjZfvi9ZTAp9c=";
    };
  };
in
stdenv.mkDerivation {
  pname = "sonoscli";
  version = "0.3.2";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/doc/sonoscli"
    cp $(find . -type f -name sonos | head -1) "$out/bin/sonos"
    chmod 0755 "$out/bin/sonos"
    if [ -f LICENSE ]; then
      cp LICENSE "$out/share/doc/sonoscli/"
    fi
    if [ -f README.md ]; then
      cp README.md "$out/share/doc/sonoscli/"
    fi
    runHook postInstall
  '';

  meta = with lib; {
    description = "Control Sonos speakers from the command-line";
    homepage = "https://github.com/steipete/sonoscli";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "sonos";
  };
}
