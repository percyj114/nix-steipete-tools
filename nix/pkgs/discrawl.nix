{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.11.3/discrawl_0.11.3_darwin_arm64.tar.gz";
      hash = "sha256-5rwHegYy2r58YRzbJNDvBfBhE86HTfRqfveckDEvlmg=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.11.3/discrawl_0.11.3_linux_amd64.tar.gz";
      hash = "sha256-C5wubCSwh6eyn5OWDFcswad1l9mjH0h2I18JuG11tsU=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.11.3/discrawl_0.11.3_linux_arm64.tar.gz";
      hash = "sha256-bAAWglgByrCFRxpkcgcELnO26NBa9ja+YWNzbLK37cg=";
    };
  };
in
stdenv.mkDerivation {
  pname = "discrawl";
  version = "0.11.3";

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
