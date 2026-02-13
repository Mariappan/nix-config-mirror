# Out-of-tree build of btintel_pcie with S4 hibernate support patch.
# Avoids full kernel recompilation when only this driver needs patching.
{
  stdenv,
  lib,
  kernel,
}:

stdenv.mkDerivation {
  pname = "btintel-pcie-s4";
  inherit (kernel) src version;

  patches = [
    ../../patches/kernel/btintel-pcie-s4-hibernate-support.patch
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  modDest = "lib/modules/${kernel.modDirVersion}/updates/drivers/bluetooth";

  buildPhase = ''
    runHook preBuild
    make \
      -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      M=$PWD/drivers/bluetooth \
      obj-m=btintel_pcie.o \
      modules
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D drivers/bluetooth/btintel_pcie.ko $out/$modDest/btintel_pcie.ko
    runHook postInstall
  '';

  meta = {
    description = "Intel Bluetooth PCIe driver with S4 hibernate support";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
