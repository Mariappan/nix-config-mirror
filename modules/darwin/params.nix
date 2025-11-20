{ lib, ... }:
{
  # Define system parameters
  options.nixma.darwin.params.primaryUser = lib.mkOption {
    type = lib.types.str;
    description = "The primary user of the system";
    example = "mariappan.ramasamy";
  };
}
