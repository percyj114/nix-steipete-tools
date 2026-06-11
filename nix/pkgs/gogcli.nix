{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.24.0/gogcli_0.24.0_darwin_arm64.tar.gz";
      hash = "sha256-LBD9VPvLm5kmVRqJ6H9oBmOrgCX59vxhGNGdTlvjdSo=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.24.0/gogcli_0.24.0_linux_amd64.tar.gz";
      hash = "sha256-SZPRJkrkOhQumY5caWZipljxPARMchAhL0QAvus46IU=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.24.0/gogcli_0.24.0_linux_arm64.tar.gz";
      hash = "sha256-85DNcddxgcMLRIyZPN8FJWcpnoFuEWGuXNMMPH1OtrI=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.24.0";

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
