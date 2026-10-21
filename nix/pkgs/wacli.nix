{ lib, stdenv, fetchurl, autoPatchelfHook }:

let
  sources = {
    "aarch64-darwin" = {
      url = "https://github.com/openclaw/wacli/releases/download/v0.23.0/wacli_0.23.0_darwin_arm64.tar.gz";
      hash = "sha256-0rZnsa1dszkT6K5j9FvphLxf7jefuOZfaM9VtvrVCmI=";
    };
    "x86_64-linux" = {
      url = "https://github.com/openclaw/wacli/releases/download/v0.23.0/wacli_0.23.0_linux_amd64.tar.gz";
      hash = "sha256-XGuSF0GrGZEPtrlYya+adOmeOF2sjCc7Ac0RWDWar4s=";
    };
    "aarch64-linux" = {
      url = "https://github.com/openclaw/wacli/releases/download/v0.23.0/wacli_0.23.0_linux_arm64.tar.gz";
      hash = "sha256-KFKuruNeNo9mLYPLPBW5PaDenbIcrm4nQRW0XmyCMl8=";
    };
  };
in
stdenv.mkDerivation {
  pname = "wacli";
  version = "0.23.0";

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
