{ config, pkgs, inputs, lib, ... }:

let
  src1 = pkgs.fetchFromGitHub {
    owner = "nappairam";
    repo = "fork-caelestia-cli";
    rev = "269cbc8235c6976256845d0289779a2532df1ed1";
    sha256 = "3IMcnF35otla0JVybaKC4PEKJTGl7lDvCM9sLCqoFUI=";
  };
  project = inputs.pyproject-nix.lib.project.loadPyproject {
      projectRoot = src1;
  };
  python = pkgs.python3;
  attrs = project.renderers.buildPythonPackage { inherit python; };

  # Caelestia scripts derivation with Python shebang fixes
  caelestia-scripts =  python.pkgs.buildPythonPackage (attrs // { env.CUSTOM_ENVVAR = "hello"; });

  # Wrap quickshell with Qt dependencies and required tools in PATH
  quickshell-wrapped = pkgs.runCommand "quickshell-wrapped" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out/bin
    makeWrapper ${inputs.quickshell.packages.${pkgs.system}.default}/bin/qs $out/bin/qs \
      --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qtbase}/${pkgs.qt6.qtbase.qtPluginPrefix}" \
      --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qt5compat}/${pkgs.qt6.qtbase.qtPluginPrefix}" \
      --prefix QML2_IMPORT_PATH : "${pkgs.qt6.qt5compat}/${pkgs.qt6.qtbase.qtQmlPrefix}" \
      --prefix QML2_IMPORT_PATH : "${pkgs.qt6.qtdeclarative}/${pkgs.qt6.qtbase.qtQmlPrefix}" \
      --prefix PATH : ${lib.makeBinPath [ pkgs.fd pkgs.coreutils ]}
  '';

in
{
  options.programs.quickshell = {
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = quickshell-wrapped;
      description = "The wrapped quickshell package with Qt dependencies";
    };

    caelestia-scripts = lib.mkOption {
      type = lib.types.package;
      default = caelestia-scripts;
      description = "The caelestia scripts package";
    };
  };
}
