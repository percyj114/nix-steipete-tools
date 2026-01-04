{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  pname = "imsg";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/steipete/imsg/releases/download/v0.2.0/imsg-macos.zip";
    hash = "sha256-ERkzEb0T2XR7vTIMcz6RAeCwYX0QQxjsOp9QMMOLV2c=";
  };

  nativeBuildInputs = [ unzip ];
  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    unzip -q "$src"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp imsg "$out/bin/imsg"
    chmod 0755 "$out/bin/imsg"
    if [ -f PhoneNumberKit_PhoneNumberKit.bundle ]; then
      cp -R PhoneNumberKit_PhoneNumberKit.bundle "$out/bin/"
    fi
    runHook postInstall
  '';

  meta = with lib; {
    description = "Send and read iMessage / SMS from the terminal";
    homepage = "https://github.com/steipete/imsg";
    license = licenses.mit;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "imsg";
  };
}
