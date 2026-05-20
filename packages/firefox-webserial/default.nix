# firefox-webserial: native messaging host that brokers Web Serial API calls
# from the Firefox/Zen extension to physical serial ports. The .xpi extension
# itself is installed from addons.mozilla.org — this derivation only ships the
# native binary plus the io.github.kuba2k2.webserial NMH manifest.
#
# Manifest lives at $out/lib/mozilla/native-messaging-hosts/, which is the path
# Firefox-family browsers scan via NIX_MOZ_NATIVE_MESSAGING_HOSTS_PATH (set by
# the wrapped firefox in nixpkgs and by the zen-browser flake's wrapper).
{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  stdenv,
}:

let
  version = "0.5.0";

  src =
    if stdenvNoCC.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/kuba2k2/firefox-webserial/releases/download/v${version}/firefox-webserial-linux-x86-64";
        hash = "sha256-L5gDCOPN7btcafxsVTTjqauky4hmkgY0artgKULDBUE=";
      }
    else
      throw "firefox-webserial: upstream only ships a linux x86-64 native host";
in
stdenvNoCC.mkDerivation {
  pname = "firefox-webserial";
  inherit version src;

  dontUnpack = true;

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/lib/firefox-webserial/firefox-webserial"

    mkdir -p "$out/lib/mozilla/native-messaging-hosts"
    cat > "$out/lib/mozilla/native-messaging-hosts/io.github.kuba2k2.webserial.json" <<EOF
    {
        "name": "io.github.kuba2k2.webserial",
        "description": "WebSerial for Firefox",
        "path": "$out/lib/firefox-webserial/firefox-webserial",
        "type": "stdio",
        "allowed_extensions": ["webserial@kuba2k2.github.io"]
    }
    EOF

    runHook postInstall
  '';

  meta = {
    description = "Native messaging host for the WebSerial-for-Firefox extension";
    homepage = "https://github.com/kuba2k2/firefox-webserial";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "firefox-webserial";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ ];
  };
}
