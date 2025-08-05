{
  lib,
  pkgs,
  fetchurl,
}:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "meslolgsnf-font";
  version = "1";
  dontConfigure = true;
  dontUnpack = true;

  regular = fetchurl {
    url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf";
    sha256 = "sha256-2XlGGG6X+NfAE56Jg6v0Ch0tCGkk8sXb8cKb2PLG5X0=";
  };
  bold = fetchurl {
    url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf";
    sha256 = "sha256-tsAZnPfHSDyDQ+oCBliSXm3grrMYuJkIFS/LTRkiYAM=";
  };
  italic = fetchurl {
    url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf";
    sha256 = "sha256-bzV7y+JZdwThV6kVYlkovKODZKicIqSsNuehFtzTku8=";
  };
  bolditalic = fetchurl {
    url = "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf";
    sha256 = "sha256-VrQTGt7OwFLEsyTvuBjdMm1Ybbwxb8aPmPHK4uuNEiA=";
  };

  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp -R ${regular} ${bold} ${italic} ${bolditalic} $out/share/fonts/truetype/
    # find . -name '*.ttf' -exec install -Dt $out/share/fonts/truetype {} \;
    # find . -name '*.otf' -exec install -Dt $out/share/fonts/opentype {} \;
  '';

  meta = with lib; {
    description = "MesloLGS NF font";
    homepage = "https://github.com/romkatv/powerlevel10k";
  };
}
