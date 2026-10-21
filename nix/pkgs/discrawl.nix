{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.16.0/discrawl_0.16.0_darwin_arm64.tar.gz";
      hash = "sha256-bhfiSJDPorRuXWL1eO83rt8hjxIpGFO02V9YB0FX4zQ=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.16.0/discrawl_0.16.0_linux_amd64.tar.gz";
      hash = "sha256-jb1FmRte2Ni3lGQyFAGqbkUgjIAaBWSN9m2llzX8GK8=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.16.0/discrawl_0.16.0_linux_arm64.tar.gz";
      hash = "sha256-XdxK4B5ZEcX582+kOnPeGAKI8eZvWVVvfwtsXe87myQ=";
    };
  };
in
stdenv.mkDerivation {
  pname = "discrawl";
  version = "0.16.0";

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
