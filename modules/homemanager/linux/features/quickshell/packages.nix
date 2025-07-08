{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  # Dummy beat_detector binary needed by caelestia shell
  pkg_beat_detector = pkgs.writeScriptBin "beat_detector" ''
    echo "BPM: 600.0"
  '';

  # Wrap quickshell with Qt dependencies and required tools in PATH
  quickshell-wrapped =
    pkgs.runCommand "quickshell-wrapped"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      }
      ''
        mkdir -p $out/bin
        makeWrapper ${inputs.quickshell.packages.${pkgs.system}.default}/bin/qs $out/bin/qs \
          --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qtbase}/${pkgs.qt6.qtbase.qtPluginPrefix}" \
          --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qt5compat}/${pkgs.qt6.qtbase.qtPluginPrefix}" \
          --prefix QML2_IMPORT_PATH : "${pkgs.qt6.qt5compat}/${pkgs.qt6.qtbase.qtQmlPrefix}" \
          --prefix QML2_IMPORT_PATH : "${pkgs.qt6.qtdeclarative}/${pkgs.qt6.qtbase.qtQmlPrefix}" \
          --prefix PATH : ${
            lib.makeBinPath [
              pkgs.fd
              pkgs.procps
              pkg_beat_detector
            ]
          }
      '';
in
{
  options.programs.quickshell = {
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = quickshell-wrapped;
      description = "The wrapped quickshell package with Qt dependencies";
    };
  };
  options.programs.beat_detector = {
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = pkg_beat_detector;
      description = "Mock beat detector";
    };
  };
}
