{
  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.daemon.settings = {
    bip = "10.254.1.1/24";
    default-address-pools = [
      {
        base = "10.254.2.0/18";
        size = 24;
      }
    ];
  };
}

