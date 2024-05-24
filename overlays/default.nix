inputs: rec {
  devenv = final: prev: {
    devenv = inputs.devenv.packages.${prev.stdenv.hostPlatform.system}.devenv;
  };
  wezterm = final: prev: {
    wezterm = inputs.wezterm.packages.${prev.stdenv.hostPlatform.system}.default;
  };
  hostapd = final: prev: {
    hostapd = prev.hostapd.overrideAttrs (oldAttrs: {
      #patches = oldAttrs.patches ++ [
      patches = [
        (prev.fetchpatch {
          # hack to work with intel LAR
          url = "https://raw.githubusercontent.com/openwrt/openwrt/eefed841b05c3cd4c65a78b50ce0934d879e6acf/package/network/services/hostapd/patches/300-noscan.patch";
          hash = "sha256-q9yWc5FYhzUFXNzkVIgNe6gxJyE1hQ/iShEluVroiTE=";
        })
      ];
    });
  };
  default = inputs.nixos.lib.composeManyExtensions [
    # devenv
    # hostapd
    wezterm

    inputs.neovim-nightly-overlay.overlay
  ];
}
