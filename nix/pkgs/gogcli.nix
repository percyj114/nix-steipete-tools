{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.19.0/gogcli_0.19.0_darwin_arm64.tar.gz";
      hash = "sha256-ql6UkVqwFXB4lMx6RBFLyTmMWqmL4Znf45z26g7p6+U=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.19.0/gogcli_0.19.0_linux_amd64.tar.gz";
      hash = "sha256-ic12tg0H9kuTHFqWSrpH3ECCEqr2/1WMGm6NwdwP0ck=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.19.0/gogcli_0.19.0_linux_arm64.tar.gz";
      hash = "sha256-sN/Ni43G04rTkBREJzs+hi7p+0m55HsjLKDpJSiSIi0=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.19.0";

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
