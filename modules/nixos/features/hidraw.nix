{ ... }:
{
  services.udev.extraRules = ''
    # Grant access to hidraw devices for input group with user access tag
    KERNEL=="hidraw*", GROUP="input", TAG+="uaccess"
  '';
}
