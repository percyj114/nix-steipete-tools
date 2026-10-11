{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.44.0/gogcli_0.44.0_darwin_arm64.tar.gz";
      hash = "sha256-5Ube8qCMgKu+8hOKfwLmP2upHc8EzJSHPS2hE7jRFsI=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.44.0/gogcli_0.44.0_linux_amd64.tar.gz";
      hash = "sha256-nkC35RvpFi5auS0lU3Ylfk1ZTp5k3DYP/8zYW6ThwMA=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.44.0/gogcli_0.44.0_linux_arm64.tar.gz";
      hash = "sha256-A0YUnKxmMJlsaZEaxzZsPBo22INbI+mF6Qw/jSXHq2U=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.44.0";

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
