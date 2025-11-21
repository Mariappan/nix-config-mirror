{ ... }:
{
  # Set the primary user for this system
  nixma.darwin.params.primaryUser = "maari";

  # Configure users
  nixma.darwin.users.maari = {
    enable = true;
    bundle = "water";
    name = "Mariappan Ramasamy";
    email = "2441529-Mariappan@users.noreply.gitlab.com";
  };
}
