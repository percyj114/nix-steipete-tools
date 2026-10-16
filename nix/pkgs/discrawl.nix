{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.15.8/discrawl_0.15.8_darwin_arm64.tar.gz";
      hash = "sha256-I/srS3OYG3QJstCvZKBr0nF3iPMrJwLevj+uh045CYo=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.15.8/discrawl_0.15.8_linux_amd64.tar.gz";
      hash = "sha256-dljUXhf8XRaPtucXZ95rtaOhWwNjGciLsqjhH3S2ZVQ=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.15.8/discrawl_0.15.8_linux_arm64.tar.gz";
      hash = "sha256-IRZa33ZSLA0AL2icAbmssE/5GMDsLYKChYmjWbFc2cY=";
    };
  };
in
stdenv.mkDerivation {
  pname = "discrawl";
  version = "0.15.8";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/doc/discrawl"
    cp $(find . -type f -name discrawl | head -1) "$out/bin/discrawl"
    chmod 0755 "$out/bin/discrawl"
    if [ -f LICENSE ]; then
      cp LICENSE "$out/share/doc/discrawl/"
    fi
    if [ -f README.md ]; then
      cp README.md "$out/share/doc/discrawl/"
    fi
    runHook postInstall
  '';

  meta = with lib; {
    description = "Mirror Discord into SQLite and search server history locally";
    homepage = "https://github.com/openclaw/discrawl";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "discrawl";
  };
}
