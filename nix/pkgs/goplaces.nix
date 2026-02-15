{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/steipete/goplaces/releases/download/v0.3.0/goplaces_0.3.0_darwin_arm64.tar.gz";
      hash = "sha256-FAhLzN7CbMghXNTLPOyaRHJjMuUt+LlDoWRV0zQSpmU=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/steipete/goplaces/releases/download/v0.3.0/goplaces_0.3.0_darwin_amd64.tar.gz";
      hash = "sha256-Rue66IenX9MX69nAwDGDMSN5+2LzzeZ8nE7N2eCvR1E=";
    };
    "x86_64-linux" = {
      url = "https://github.com/steipete/goplaces/releases/download/v0.3.0/goplaces_0.3.0_linux_amd64.tar.gz";
      hash = "sha256-z6eNTZo2K7wsPT/3d3Fg+1pZlN5+hSGwBIG3LUBTsec=";
    };
    "aarch64-linux" = {
      url = "https://github.com/steipete/goplaces/releases/download/v0.3.0/goplaces_0.3.0_linux_arm64.tar.gz";
      hash = "sha256-IhwA/xN7SqdoNd7WB+RtOKHsmGyo+62IZDBEDWfevRs=";
    };
  };

  meta = with lib; {
    description = "Modern Go client + CLI for the Google Places API (New)";
    homepage = "https://github.com/steipete/goplaces";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "goplaces";
  };

in
stdenv.mkDerivation {
  pname = "goplaces";
  version = "0.3.0";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/share/doc/goplaces"
    cp $(find . -type f -name goplaces | head -1) "$out/bin/goplaces"
    chmod 0755 "$out/bin/goplaces"
    if [ -f LICENSE ]; then
      cp LICENSE "$out/share/doc/goplaces/"
    fi
    if [ -f README.md ]; then
      cp README.md "$out/share/doc/goplaces/"
    fi
    runHook postInstall
  '';

  inherit meta;
}
