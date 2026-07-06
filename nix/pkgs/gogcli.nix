{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.33.0/gogcli_0.33.0_darwin_arm64.tar.gz";
      hash = "sha256-1zsyT6OjWggXVDJ2HIv9QQiWsaIjZaqJiQrE+/33xm4=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.33.0/gogcli_0.33.0_linux_amd64.tar.gz";
      hash = "sha256-hlNH4ioDTe52OOAIUrxJhli3RIh1nvUiPkUXzTlQ5y0=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.33.0/gogcli_0.33.0_linux_arm64.tar.gz";
      hash = "sha256-FFM2J3C2XrjWPjH+NnepOqHhFafSxmKASfxHfpA6Um4=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.33.0";

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
