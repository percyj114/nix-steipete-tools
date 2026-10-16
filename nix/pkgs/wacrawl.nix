{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/wacrawl/releases/download/v0.4.3/wacrawl_0.4.3_darwin_arm64.tar.gz";
      hash = "sha256-tIzDqgI6bT+UUFQPv45rhMDKqy1w5gvoIwvKGKr+IvU=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/wacrawl/releases/download/v0.4.3/wacrawl_0.4.3_linux_amd64.tar.gz";
      hash = "sha256-TYSLfC/oC+5QlwtADy5WziDbl1b8h/FVrjqg3vtnNmw=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/wacrawl/releases/download/v0.4.3/wacrawl_0.4.3_linux_arm64.tar.gz";
      hash = "sha256-LpLaWjZnY4jj8hGKE7nlBi0kWIBDWbllhQTWfzSYSEI=";
    };
  };
in
stdenv.mkDerivation {
  pname = "wacrawl";
  version = "0.4.3";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/doc/wacrawl"
    cp $(find . -type f -name wacrawl | head -1) "$out/bin/wacrawl"
    chmod 0755 "$out/bin/wacrawl"
    if [ -f LICENSE ]; then
      cp LICENSE "$out/share/doc/wacrawl/"
    fi
    if [ -f README.md ]; then
      cp README.md "$out/share/doc/wacrawl/"
    fi
    runHook postInstall
  '';

  meta = with lib; {
    description = "Read-only local archive and search for WhatsApp Desktop data";
    homepage = "https://github.com/steipete/wacrawl";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "wacrawl";
  };
}
