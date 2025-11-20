{ lib, ... }:
{
  # Define system parameters
  options.nixma.nixos.params.primaryUser = lib.mkOption {
    type = lib.types.str;
    description = "The primary user of the system";
    example = "maari";
  };
}
