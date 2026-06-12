{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.25.0/gogcli_0.25.0_darwin_arm64.tar.gz";
      hash = "sha256-RhTK+J1ZeoRnhZmUJYClIf2E40E372yu2IPRFYDRjhM=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.25.0/gogcli_0.25.0_linux_amd64.tar.gz";
      hash = "sha256-70ozyMpQrOZov/QiWhgvusQXvh9edmD3SsW0HE7N0hk=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/gogcli/releases/download/v0.25.0/gogcli_0.25.0_linux_arm64.tar.gz";
      hash = "sha256-cnTSaOCP/OEeFrx68jaes5Xm44TUCn6I2AXHIprPMmE=";
    };
  };
in
stdenv.mkDerivation {
  pname = "gogcli";
  version = "0.25.0";

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
