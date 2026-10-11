{ lib, stdenv, fetchurl }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.15.7/discrawl_0.15.7_darwin_arm64.tar.gz";
      hash = "sha256-wLulfXlvLgwbFwEPEu5M8/YcNR423CaaKqZTRqPHVhY=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.15.7/discrawl_0.15.7_linux_amd64.tar.gz";
      hash = "sha256-mSJUJ6RR8CfE2C/KuIp7XkzzYqQ0zZrK0M9x1QXOxPE=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/discrawl/releases/download/v0.15.7/discrawl_0.15.7_linux_arm64.tar.gz";
      hash = "sha256-3PoePnyBXISD+0K6otoFUHYhZhSDCkpBhjWDTfY0IfY=";
    };
  };
in
stdenv.mkDerivation {
  pname = "discrawl";
  version = "0.15.7";

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
