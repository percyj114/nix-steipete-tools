{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/steipete/gogcli/releases/download/v0.14.0/gogcli_0.14.0_darwin_arm64.tar.gz";
      hash = "sha256-qJ+H7dc+oPn7E57kvEIwlAc990nkpiGSqlFCDy9kZjo=";
    };
    "x86_64-linux" = {
      url = "https://github.com/steipete/gogcli/releases/download/v0.14.0/gogcli_0.14.0_linux_amd64.tar.gz";
      hash = "sha256-sq2qUDYnqlbZGGzxBHp5CqFfjdGFIkgN1P8UBgyd0hs=";
    };
    "aarch64-linux" = {
      url = "https://github.com/steipete/gogcli/releases/download/v0.14.0/gogcli_0.14.0_linux_arm64.tar.gz";
      hash = "sha256-KOq4AyYyjUvL6tMq4WtOZu2WYTdtJR1g44uFmJt8oHs=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.14.0";

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
    homepage = "https://github.com/steipete/gogcli";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "gog";
  };
}
