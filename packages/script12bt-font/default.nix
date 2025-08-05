{
  lib,
  pkgs,
}:
pkgs.stdenvNoCC.mkDerivation {
  name = "script12bt-font";
  dontConfigue = true;
  src = ./modified_1966_SCRPT12N.TTF;
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp -R $src $out/share/fonts/truetype/
  '';
  meta = with lib; {
    description = "Script12Bt font with customizations";
    homepage = "https://www.cufonfonts.com/font/script12-bt";
  };
}
