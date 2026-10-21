{ lib, stdenv, fetchurl, autoPatchelfHook }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/wacli/releases/download/v0.24.0/wacli_0.24.0_darwin_arm64.tar.gz";
      hash = "sha256-1HQWsbZ/rHr5WT+aVvHMpvN36ksEhqh2bbuA8Qz9728=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/wacli/releases/download/v0.24.0/wacli_0.24.0_linux_amd64.tar.gz";
      hash = "sha256-TKXGaNQfaLrRi/EueWarp8GzzGrjL9jhRd65h93RGS0=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/wacli/releases/download/v0.24.0/wacli_0.24.0_linux_arm64.tar.gz";
      hash = "sha256-bg+1RHPesPuHgjk88fIfDB47szAbNlHNnZp3tjePDgc=";
    };
  };
in
stdenv.mkDerivation {
  pname = "wacli";
  version = "0.24.0";

  # Upstream builds ./cmd/wacli with Go 1.27+, CGO_ENABLED=1 and sqlite_fts5.
  src = fetchurl sources.${stdenv.hostPlatform.system};

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.libc ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf "$src"
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 wacli "$out/bin/wacli"
    install -Dm644 LICENSE "$out/share/doc/wacli/LICENSE"
    install -Dm644 README.md "$out/share/doc/wacli/README.md"
    runHook postInstall
  '';

  meta = with lib; {
    description = "WhatsApp linked-device CLI for synchronization, search, and sending";
    homepage = "https://github.com/openclaw/wacli";
    license = licenses.mit;
    platforms = builtins.attrNames sources;
    mainProgram = "wacli";
  };
}
